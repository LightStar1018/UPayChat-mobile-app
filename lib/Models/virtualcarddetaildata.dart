class VirtualCardListModel {
  String status = '';
  String message = '';
  List<VirtualCardDetailData>? cardlist;

  VirtualCardListModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.cardlist =
        (obj['data'] as List).map((i) => VirtualCardDetailData.fromJson(i)).toList();
  }
}
class VirtualCardDetailDataModel{
  String status = '';
  String message = '';
  VirtualCardDetailData? cardData;
  VirtualCardDetailDataModel.map(dynamic obj){
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    // print(obj);
    cardData = VirtualCardDetailData.fromJson(obj["card_data"]);
  }
}
class VirtualCardFullDetailDataModel{
  String status = '';
  String message = '';
  VirtualCardFullDetailData? cardData;

  VirtualCardFullDetailDataModel.map(dynamic obj){
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    // print(obj);
    cardData = VirtualCardFullDetailData.fromJson(obj["card_data"]);
  }
}

class VirtualCardTransaction {
  String id = '';
  double amount = 0;
  int created = 0;
  VirtualCardTransaction.fromJson(Map jsonMap)
      :id = jsonMap['id'].toString(),
        amount = double.parse(jsonMap['amount'].toString()),
        created = int.parse(jsonMap['created'].toString());

}
class VirtualCardFullDetailData{
  int id = 0;
  String card_number = '';
  String expire_date = '';
  String card_holder = '';
  String card_status = '';
  double card_balance = 0.00;
  String card_ccv = '';
  List<dynamic>? cardTransactions;
  VirtualCardFullDetailData(
      this.id, this.card_number, this.expire_date,this.card_holder, this.card_status, this.card_ccv);

  VirtualCardFullDetailData.fromJson(Map jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        card_number = jsonMap['card_number'].toString(),
        expire_date = jsonMap['expire_date'].toString(),
        card_holder = jsonMap['card_holder'].toString(),
        card_status = jsonMap['card_status'].toString(),
        card_ccv = jsonMap['card_ccv'].toString(),
        card_balance = double.parse(jsonMap['card_balance'].toString()),
        cardTransactions = (jsonMap['transactions'] as List).map((i) => i).toList();
}
class VirtualCardDetailData {
   int id = 0;
   String card_number = '';
   String expire_date = '';
   String card_holder = '';
   String card_status = '';
   double card_balance = 0.00;

  VirtualCardDetailData(
      this.id, this.card_number, this.expire_date,this.card_holder, this.card_status);

  VirtualCardDetailData.fromJson(Map jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        card_number = jsonMap['card_number'].toString(),
        expire_date = jsonMap['expire_date'].toString(),
        card_holder = jsonMap['card_holder'].toString(),
        card_status = jsonMap['status'].toString(),
        card_balance = double.parse(jsonMap['balance'].toString()) ;


}
