class FlutterwaveCategoriesModel {
  String status = '';
  String message = '';
  List<FlutterwaveCategoriesData> categoriesList = [];

  FlutterwaveCategoriesModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    List resultList = obj['data'] as List;
    final usedShortName = <String>[];
    for (int i = 0; i < resultList.length; i++) {
      FlutterwaveCategoriesData tmpData =
          FlutterwaveCategoriesData.fromJson(obj['data'][i]);
      String shortName = tmpData.biller_name;

      if (usedShortName.indexOf(shortName) == -1) {
        usedShortName.add(shortName);
        if (tmpData.country == "NG") {
          this.categoriesList.add(tmpData);
        }
      }
    }
    //
    // this.categoriesList =
    //     (obj['data'] as List).map((i) => {
    //       return FlutterwaveCategoriesData.fromJson(i);
    //     }).toList();
  }
}

class FlutterwaveCategoriesData {
  String id;
  String biller_code;
  String name;
  double default_commission;
  String date_added; //": "2018-07-03T00:00:00Z",
  String country; //": "NG",
  String is_airtime; //": true,
  String biller_name; //": "AIRTIME",
  String item_code; //": "AT099",
  String short_name; //": "MTN",
  int fee; //": 0,
  String commission_on_fee; //": false,
  String label_name; //": "Mobile Number",
  int amount; //": 0

  FlutterwaveCategoriesData.fromJson(Map jsonMap)
      : id = jsonMap['id'].toString(),
        biller_code = jsonMap['biller_code'].toString(),
        name = jsonMap['name'].toString(),
        default_commission =
            double.parse(jsonMap['default_commission'].toString()),
        date_added = jsonMap['date_added'].toString(),
        country = jsonMap['country'].toString(),
        is_airtime = jsonMap['is_airtime'].toString(),
        biller_name = jsonMap['biller_name'].toString(),
        item_code = jsonMap['item_code'].toString(),
        short_name = jsonMap['short_name'].toString(),
        fee = int.parse(jsonMap['fee'].toString()),
        commission_on_fee = jsonMap['commission_on_fee'].toString(),
        label_name = jsonMap['label_name'].toString(),
        amount = int.parse(jsonMap['amount'].toString());
}
