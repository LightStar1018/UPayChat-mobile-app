class WalletModel {
  String status = '';
  String message = '';
  String balance = '';
  String paystackPubKey = '';
  String paystackSecKey = '';
  String flutterwavePubKey = '';
  String flutterwaveSecKey = '';
  String  quickMerchantID = "";
  String  quickMerchantCode = "";
  String  quickMerchantSecret = "";
  WalletModel() {}

  WalletModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"].toString();
      this.message = obj["message"].toString();
      this.balance = obj["data"]["balance"].toString();
      this.paystackPubKey = obj["data"]["paystackPubKey"].toString();
      this.paystackSecKey = obj["data"]["paystackSecKey"].toString();
      this.flutterwavePubKey = obj["data"]["flutterwavePubKey"].toString();
      this.flutterwaveSecKey = obj["data"]["flutterwaveSecKey"].toString();

      this.quickMerchantID = obj["data"]["quickMerchantID"].toString();
      this.quickMerchantCode = obj["data"]["quickMerchantCode"].toString();
      this.quickMerchantSecret = obj["data"]["quickMerchantSecret"].toString();
    }
  }
}
