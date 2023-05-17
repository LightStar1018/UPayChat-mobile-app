class FlutterwaveBillingCreatedModel {
  String status = '';
  String message = '';
  FlutterwaveBillingCreatedData? billingResult;

  FlutterwaveBillingCreatedModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.billingResult =
    obj['data'] == null ? null : FlutterwaveBillingCreatedData.fromJson(obj['data']);
  }
}

class FlutterwaveBillingCreatedData {
  String? flw_ref;
  String? reference;


  FlutterwaveBillingCreatedData.fromJson(dynamic jsonMap)
      :flw_ref = jsonMap['flw_ref'].toString(),
        reference = jsonMap['reference'].toString();
}
