import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upaychat/Apis/removesavedcardapi.dart';
import 'package:upaychat/globals.dart';
import '../Apis/getcardtokensapi.dart';
import '../CommonUtils/common_utils.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:eventhandler/eventhandler.dart';
import '../CommonUtils/preferences_manager.dart';
import '../CommonUtils/string_files.dart';
import 'package:upaychat/Events/balanceevent.dart';

import '../Pages/paystack_checkout_file.dart';
class PayWithSavedCard extends StatefulWidget{
  String accessCode = '';
  List<SavedCardDetails> cardList = [];
  double totalAmount = 0.0;
  double amount = 0.0;
  PaystackPlugin? plugin;
  PayWithSavedCard(String _accessCode,List<SavedCardDetails> _cardList, double _totalAmount, double _amount, PaystackPlugin _plugin){
    this.accessCode = _accessCode;
    this.cardList = _cardList;
    this.amount = _amount;
    this.totalAmount = _totalAmount;
    this.plugin = _plugin;
  }
  @override
  State<StatefulWidget> createState() {
    return PayWithSavedCardState();
  }
}
class PayWithSavedCardState extends State<PayWithSavedCard> {
  List<SavedCardDetails> cardList = [];
  bool isTokenCharging = false;

  void initState() {
    setState(() {
      cardList = widget.cardList;
    });
    super.initState();
  }
  buildCardList() {
    final children = <Widget>[];
    for (var i = 0; i < cardList.length; i++) {
      children.add(Container(
          child: Container(
              height: 56,
              // width: 56,
              width: double.infinity,
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'icons/${cardList[i].brand}.png',
                    height: 48,
                    width: 48,
                    package: 'flutter_credit_card',
                  ),
                  Expanded(child: InkWell(
                      onTap: () {
                        chargeWithPaystackTokenization(cardList[i].authorization_code ?? '');
                      },
                      child: Text(
                        'Card ending in ${(cardList[i].last4 ?? '')}',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      )))
                  ,
                  InkWell(
                    onTap: (){
                      print('Remove Card');
                      String cardID = cardList[i].id!;
                      if(Globals.isOnline){
                        setState(() {
                          cardList = List.from(cardList)
                            ..removeAt(i);

                        });
                        RemoveSavedCardApi _removeApi = new RemoveSavedCardApi();
                        _removeApi.search(cardID);
                      }
                      else{
                        CommonUtils.errorToast(context,StringMessage.network_Error);
                      }

                    },

                    child: Icon(Icons.close, color: Colors.red,),
                  )

                ],
              ))));
    }
    return Column(
      children: children,
    );
  }
  @override
  Widget build(BuildContext context) {
    var mWidth = MediaQuery.of(context).size.width;
    return Container(
      width: mWidth * 0.8,

      child: isTokenCharging ? Container(height: 50,child: CommonUtils.progressDialogBox()) : SingleChildScrollView(
        child: ListBody(
          children: <Widget>[

            buildCardList(),
            TextButton(
              child: Container(
                  height: 56,
                  // width: 56,
                  width: double.infinity,
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),

                  child: Row(
                    children: <Widget>[

                      Text(
                        'Pay with new card',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop('paystack');
                 // chargeFromPaystackCard(widget.accessCode);

              },
            ),
          ],
        ),
      ),
    );
  }
  void chargeFromPaystackCard(accessCode) async{
    Charge charge = Charge()
      ..amount = (widget.totalAmount * 100).round()
      ..accessCode = accessCode
      ..email = PreferencesManager.getString(StringMessage.email);
    CheckoutResponse response = await widget.plugin!.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status) {
      // _showDialog(totalAmount, amount, mode);
      EventHandler().send(BalanceEvent(''));
      CommonUtils.successToast(
          context, "Your payment has been successfully processed.");
      Navigator.pop(context);

      Navigator.pop(context);
    } else {


      CommonUtils.errorToast(context, response.message);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
  chargeWithPaystackTokenization(String authCode) async{

    try{
      setState(() {
        isTokenCharging = true;
      });
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization':
        'Bearer ' + PreferencesManager.getString(StringMessage.paystackSecKey)
      };
      Map data = {
        "amount": (widget.totalAmount * 100).round(),
        "email": PreferencesManager.getString(StringMessage.email),
        "authorization_code": authCode,
        "metadata" : {
          "charge_amount": widget.amount.toString(),
          "cancel_action" : "upaychat://cancel"
        },
        "callback_url": "upaychat://success"
      };
      String payload = json.encode(data);
      http.Response response = await http.post(
        Uri.parse('https://api.paystack.co/transaction/charge_authorization'),
        headers: headers,
        body: payload,
      );

      Map responseChargeAuth =jsonDecode(response.body);
      if(responseChargeAuth['status'].toString() == 'true'){
        if(responseChargeAuth.containsKey('data')){
          Map responseData = responseChargeAuth['data'] as Map<String, dynamic>;
          print(responseData);
          if(responseData.containsKey('authorization_url') && responseChargeAuth['data']['authorization_url'].toString() != ''){
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaystackCheckoutFile(
                        redirectUrl: 'https://checkout.paystack.com/${responseChargeAuth['data']['authorization_url']}',
                        reference:
                        'upaychat${DateTime.now().microsecondsSinceEpoch.toString()}')))
                .then((data) {
              if (data == 'success') {
                EventHandler().send(BalanceEvent(''));
                Navigator.pop(context);
                Navigator.pop(context);
                CommonUtils.successToast(
                    context, "Your payment has been successfully processed.");
              } else {
                Navigator.pop(context);
                // CommonUtils.errorToast(context, "Payment has been canceled.");
              }
            });
            if (!mounted) return;
          }
          else if(responseData.containsKey('status') && responseChargeAuth['data']['status'].toString() == 'success'){

            EventHandler().send(BalanceEvent(''));
            Navigator.pop(context);
            Navigator.pop(context);
            CommonUtils.successToast(
                context, "Your payment has been successfully processed.");
          }
          else{

            Navigator.pop(context);
            Navigator.pop(context);

            CommonUtils.errorToast(context, responseData['gateway_response']);
          }
          setState(() {
            isTokenCharging = false;
          });
        }
      }
      else{
        Navigator.pop(context);
        Navigator.pop(context);
        CommonUtils.errorToast(context, 'Error in Checkout');
        setState(() {
          isTokenCharging = false;
        });
      }
    }
    catch(e){
      print(e);
      Navigator.pop(context);
      Navigator.pop(context);
      CommonUtils.errorToast(context, 'Error in Checkout');
      setState(() {
        isTokenCharging = false;
      });
    }



  }
}