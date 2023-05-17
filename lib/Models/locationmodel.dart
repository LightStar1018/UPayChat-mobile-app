class LocationModel {
  String status = '';
  String message = '';
  List<LocationData>? locationData;

  LocationModel.map(dynamic obj) {
    status = obj["status"].toString();
    message = obj["message"].toString();
    locationData = (obj['data'] as List).map((i) => LocationData.fromJson(i)).toList();
  }
}

class LocationData {
  String userId;
  String latitude;
  String longitude;
  String address;
  String distance;
  String firstname;
  String lastname;
  String avatar;
  String mobile;

  LocationData.fromJson(Map jsonMap)
      : userId = jsonMap['user_id'].toString(),
        latitude = jsonMap['latitude'].toString(),
        longitude = jsonMap['longitude'].toString(),
        address = jsonMap['address'].toString(),
        distance = jsonMap['distance'].toString(),
        firstname = jsonMap['firstname'].toString(),
        lastname = jsonMap['lastname'].toString(),
        mobile = jsonMap['mobile'].toString(),
        avatar = jsonMap['avatar'].toString();
}