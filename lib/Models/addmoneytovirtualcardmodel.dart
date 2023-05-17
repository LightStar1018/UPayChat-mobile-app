class AddMoneyToVirtualCardModel {
  String status = '';
  String message = '';
  String balance = '';
  String cardBalance = '';
  AddMoneyToVirtualCardModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"].toString();
      this.message = obj["message"].toString();
      if (status == "true") {
        this.balance = obj['data']['balance'].toString();
        this.cardBalance = obj['data']['card_balance'].toString();
      }
    }
  }
}
