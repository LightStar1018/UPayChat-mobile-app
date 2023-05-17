
import 'dart:ui';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
class VirtualCardWidget{
  FlipCardController? _controller;
  FlipCard buildCreditCardFullDetails(Color color, String _cardNumber, String cardHolder,
      String cardExpiration, String cardCCV, GlobalKey<FlipCardState> cardKey){
      return FlipCard(
        key: cardKey,
        controller: _controller,
        direction: FlipDirection.HORIZONTAL,
        speed: 1000,
        onFlipDone: (status) {
          print(status);
        },
        front: buildCreditCard(color, _cardNumber, cardHolder, cardExpiration, cardNumberMode: "full"),
        back: buildCreditCardBack(color,cardCCV),

      );
  }
Card buildCreditCardBack(Color color,String cardCCV){
    print("Card CCV");
    print(cardCCV);
    return Card(
      elevation: 4.0,
      color: color,
      /*1*/
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(
        bottom: 12.0, top: 15),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.black,
            ),
            SizedBox(height: 7,),
            Container(
              height: 50,
                width: double.infinity,
                // color: Colors.black,
              child:Row(

                children: <Widget>[
                  Expanded(
                     child: Container( height: 50,
                         color: Colors.black12)
                  ),
                  Container(
                    height: 30,
                    width: 50,
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      cardCCV,
                      style: TextStyle(
                          color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Doomsday"
                      ),
                    ),
                  )

                ],
              )

            ),
            SizedBox(height: 17,),
            Row(
              /*1*/
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(

                    child:Container()

                  )
                  ,
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child:Image.asset(

                      "assets/icons8-visa-150.png",
                      height: 34,
                      width: 50,

                    ),
                  )

                ])

          ],
        ),
      )
    );
}
Card buildCreditCard(Color color, String _cardNumber, String cardHolder,
    String cardExpiration, {String cardNumberMode = "security"}) {
  String newCardNumber =  CommonUtils.cardNumberHolder(_cardNumber);
  if(cardNumberMode != null){
    if(cardNumberMode == "full"){
      newCardNumber = CommonUtils.fullCardNumberHolder(_cardNumber);
    }
  }

  return Card(
    elevation: 4.0,
    color: color,
    /*1*/
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    child: Container(
      height: 200,
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 12.0, top: 12),
      child: Column(
        /*2*/
        crossAxisAlignment: CrossAxisAlignment.start,
        /*3*/
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          /* Here we are going to place the _buildLogosBlock */
          _buildLogosBlock(),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            /* Here we are going to place the Card number */
            child: Text(
              '$newCardNumber',
              style: TextStyle(
                  color: Colors.white, fontSize: 21, fontFamily: 'Doomsday'),
            ),
          ),
          _buildDetailsBlock(
            label: 'VALID\nTHRU',
            value: cardExpiration,
          ),

          Row(
            /*1*/
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child:Text(
                    cardHolder,

                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Arial',
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),

                )
                ,
                Image.asset(

                  "assets/icons8-visa-150.png",
                  height: 23,
                  width: 65,

                ),
              ])
        ],
      ),
    ),
  );
}

Row _buildLogosBlock() {
  return Row(
    /*1*/

    textDirection: TextDirection.rtl,
    children: <Widget>[
      Text(
        'UpayChat',
        style: TextStyle(
          fontFamily: 'Doomsday',
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      SizedBox(
        width: 6,
      ),
      Image.asset(
        "assets/logo_white.png",
        height: 20,
        width: 18,
      ),
    ],
  );
}

Row _buildDetailsBlock({required String label, required String value}) {
  return Row(
    children: <Widget>[
      Text(
        '$label',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Doomsday',
            fontSize: 7,
            fontWeight: FontWeight.bold),
      ),
      SizedBox(width : 4, ),
      Text(
        '$value',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Doomsday',
            fontSize: 17,
            fontWeight: FontWeight.bold),
      )
    ],
  );
}
}