class LoginModel {
  String status = '';

  String message = '';
  String token = '';

  int id = -1;
  String firstname = '';
  String lastname = '';
  String username = '';
  String email = '';
  String mobile = '';
  String roll = '';
  String birthday = '';
  String profile_image = '';
  String loginID = '';
  bool notification_push_money_received = true;
  bool notification_push_money_sent = true;
  bool notification_push_bank_withdraw= true;
  bool notification_push_likes= true;
  bool notification_push_comments= true;
  bool notification_sms_money_received= true;
  bool notification_sms_money_sent= true;
  bool notification_email_money_received= true;
  bool notification_email_money_sent= true;
  bool notification_email_bank_withdraw= true;



  LoginModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"].toString();
      this.message = obj["message"].toString();
      this.token = obj["token"].toString();
      if (status == "true") {
        this.id = int.parse(obj['data']["id"].toString());
        this.firstname = obj['data']["firstname"].toString();
        this.lastname = obj['data']["lastname"].toString();
        this.username = obj['data']["username"].toString();
        this.email = obj['data']["email"].toString();
        this.birthday = obj['data']["birthday"].toString();
        this.mobile = obj['data']["mobile"].toString();
        this.roll = obj['data']["roll"].toString();
        this.profile_image = obj['data']['profile_image'].toString();

        this.notification_push_money_received=obj['data']['notification_push_money_received'].toString() == '1' ? true : false;
        this.notification_push_money_sent=obj['data']['notification_push_money_sent'].toString() == '1' ? true : false;
        this.notification_push_bank_withdraw=obj['data']['notification_push_bank_withdraw'].toString() == '1' ? true : false;
        this.notification_push_likes=obj['data']['notification_push_likes'].toString() == '1' ? true : false;
        this.notification_push_comments=obj['data']['notification_push_comments'].toString() == '1' ? true : false;
        this.notification_sms_money_received=obj['data']['notification_sms_money_received'].toString() == '1' ? true : false;
        this.notification_sms_money_sent=obj['data']['notification_sms_money_sent'].toString() == '1' ? true : false;
        this.notification_email_money_received=obj['data']['notification_email_money_received'].toString() == '1' ? true : false;
        this.notification_email_money_sent=obj['data']['notification_email_money_sent'].toString() == '1' ? true : false;
        this.notification_email_bank_withdraw=obj['data']['notification_email_bank_withdraw'].toString() == '1' ? true : false;
      }
    }
  }
}
