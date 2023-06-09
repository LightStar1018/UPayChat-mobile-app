class PendingRequestModel {
  String status = '';
  String message = '';
  List<PendingRequestData> pendingRequestList = List.empty();

  PendingRequestModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.pendingRequestList = (obj['data'] as List)
        .map((i) => PendingRequestData.fromJson(i))
        .toList();
  }
}

class PendingRequestData {
  int id;
  String amount;
  String timestamp;
  int fromuser_id;
  String to_userimage;
  String message;
  String privacy;
  String caption;
  String transaction_type;
  String transaction_id;
  int status;

  PendingRequestData.fromJson(Map jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        amount = jsonMap['amount'].toString(),
        timestamp = jsonMap['timestamp'].toString(),
        fromuser_id = int.parse(jsonMap['fromuser_id'].toString()),
        to_userimage = jsonMap['to_userimage'].toString(),
        message = jsonMap['message'].toString(),
        caption = jsonMap['caption'].toString(),
        privacy = jsonMap['privacy'].toString(),
        transaction_type = jsonMap['transaction_type'].toString(),
        transaction_id = jsonMap['transaction_id'].toString(),
        status = int.parse(jsonMap['status'].toString());


}
