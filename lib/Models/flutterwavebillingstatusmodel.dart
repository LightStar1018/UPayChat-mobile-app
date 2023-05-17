class FlutterwaveBillingStatusModel {
  String status = '';
  String message = '';
  FlutterwaveBillingStatusData? billingResult;

  FlutterwaveBillingStatusModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.billingResult =
    obj['data'] == null ? null : FlutterwaveBillingStatusData.fromJson(obj['data']);
  }
}

class FlutterwaveBillingStatusData {
  String? currency;
  String? customer_id;
  String? frequency;
  String? amount;
  String? product;
  String? product_name;
  String? transaction_date;
  String? country;
  String? tx_ref;
  String? extra;
  String? product_details;



  FlutterwaveBillingStatusData.fromJson(dynamic jsonMap)
      :currency = jsonMap['currency'].toString(),
        frequency = jsonMap['frequency'].toString(),
        amount = jsonMap['amount'].toString(),
        product = jsonMap['product'].toString(),
        product_name = jsonMap['product_name'].toString(),
        transaction_date = jsonMap['transaction_date'].toString(),
        country = jsonMap['country'].toString(),
        tx_ref = jsonMap['tx_ref'].toString(),
        extra = jsonMap['extra'].toString(),
        product_details = jsonMap['product_details'].toString(),
        customer_id = jsonMap['customer_id'].toString();
}
