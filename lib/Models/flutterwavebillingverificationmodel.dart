class FlutterwaveBillingVerificationModel {
  String status = '';
  String message = '';
  FlutterwaveBillingVerificationData? verificationData;

  FlutterwaveBillingVerificationModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.verificationData =
    obj['data'] == null ? null : FlutterwaveBillingVerificationData.fromJson(obj['data']);
  }
}

class FlutterwaveBillingVerificationData {
  String? address;
  String? response_message;
  String? name;
  String? biller_code;
  String? customer;
  String? product_code;
  String? email;
  int? minimum;
  int? maximum;

  FlutterwaveBillingVerificationData.fromJson(dynamic jsonMap)
        :address = jsonMap['address'].toString(),
        response_message = jsonMap['response_message'].toString(),
        name = jsonMap['name'].toString(),
        biller_code = jsonMap['biller_code'].toString(),
        customer = jsonMap['customer'].toString(),
        product_code = jsonMap['product_code'].toString(),
        email = jsonMap['email'] != null ? jsonMap['email'].toString() : '',
        minimum = int.parse(jsonMap['minimum'].toString()),
        maximum = int.parse(jsonMap['maximum'].toString());
}
