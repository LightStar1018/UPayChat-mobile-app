class RequestModel {
  String status = '';
  String message = '';
  List<RequestData>? requestData;

  RequestModel.map(dynamic obj) {
    status = obj["status"].toString();
    message = obj["message"].toString();
    requestData = (obj['data'] as List).map((i) => RequestData.fromJson(i)).toList();
  }
}

class RequestData {
  String posId;
  String frId;
  String toId;
  String amount;
  String state;
  String frAvatar;
  String frUsername;
  String frAddress;
  String frLongitude;
  String frLatitude;
  String distance;
  String mobile;

  RequestData.fromJson(Map jsonMap)
      : posId = jsonMap['pos_id'].toString(),
        frId = jsonMap['fr_id'].toString(),
        toId = jsonMap['to_id'].toString(),
        amount = jsonMap['amount'].toString(),
        state = jsonMap['state'].toString(),
        frAvatar = jsonMap['fr_avatar'].toString(),
        frUsername = jsonMap['fr_username'].toString(),
        frAddress = jsonMap['address'].toString(),
        frLongitude = jsonMap['longitude'].toString(),
        frLatitude = jsonMap['latitude'].toString(),
        distance = jsonMap['distance'].toString(),
        mobile = jsonMap['mobile'].toString();
}

