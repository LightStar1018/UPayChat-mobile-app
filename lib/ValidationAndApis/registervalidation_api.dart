import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:platform_device_id/platform_device_id.dart';
import 'package:upaychat/Apis/check_email_api.dart';
import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:upaychat/Models/loginmodel.dart';
import 'package:upaychat/Pages/add_user_profile.dart';
import 'package:upaychat/Pages/pincode_verification_file.dart';
import 'package:upaychat/globals.dart';

class RegisterValidation {
  static checkBasicDetailForRegister(
      BuildContext context,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController) async {
    if (Globals.isOnline) {
      if (CommonUtils.isEmpty(firstNameController, 2)) {
        CommonUtils.errorToast(context, StringMessage.firstname_Error);
      } else if (CommonUtils.isEmpty(lastNameController, 2)) {
        CommonUtils.errorToast(context, StringMessage.lastname_Error);
      } else if (CommonUtils.isEmpty(emailController, 5)) {
        CommonUtils.errorToast(context, StringMessage.enter_correct_email);
      } else if (CommonUtils.validateEmail(emailController.text) == false) {
        CommonUtils.errorToast(context, StringMessage.enter_correct_email);
      } else if (CommonUtils.isEmpty(passwordController, 6)) {
        CommonUtils.errorToast(context, StringMessage.enter_correct_password);
      } else if (passwordController.text != confirmPasswordController.text) {
        CommonUtils.errorToast(
            context, StringMessage.enter_correct_confirm_password);
      } else {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        String? device_id, device_name;
        if(Platform.isAndroid){
          AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
          device_name = androidDeviceInfo.model;
          device_id = androidDeviceInfo.id;
        }
        else{
          IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
          device_name = iosDeviceInfo.utsname.machine;
        }
        Map data = {
          'firstname': firstNameController.text,
          'lastname': lastNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'device_id': device_id ?? '',
          'mobile_os': Platform.isAndroid ? 'Android' : 'iOS',
          'device_name': device_name,
        };
        CommonUtils.showProgressDialogComplete(context, false);
        CheckEmailApi _checkEmailApi = new CheckEmailApi();
        CommonModel result;
        try {
          result = await _checkEmailApi.search(emailController.text);
        } catch (e) {
          result = CommonModel("false", "", null);
        }
        Navigator.pop(context);

        if (result.status == "true") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PinCodeVerificationScreen(
                      address: emailController.text,
                      isEmail: true,
                      isExists: false,
                      code: result.message,
                      onResponse: (state) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddUserProfile(map: data)));
                      })));
        } else {
          CommonUtils.errorToast(context, result.message);
        }
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  static userNameValidation(
      BuildContext context,
      TextEditingController userNameController,
      DateTime birthday,
      Map data,
      File? image) async {
    CommonUtils.showProgressDialogComplete(context, false);
    await Future.delayed(Duration(milliseconds: 150));
    if (Globals.isOnline) {
      try{
        print(birthday);
        if (CommonUtils.isEmpty(userNameController, 2)) {
          Navigator.pop(context);
          CommonUtils.errorToast(context, StringMessage.username_Error);
        } else if (birthday == null) {
          Navigator.pop(context);
          CommonUtils.errorToast(context, StringMessage.dob_Error);
        } else {


          _callMultipartRequestForImageAndRegister(
              context, userNameController.text, birthday, data, image);
        }
      }
      catch(e){
        // Navigator.pop(context);
        CommonUtils.errorToast(context, StringMessage.network_Error);
      }
    } else {
      Navigator.pop(context);
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  static void _callMultipartRequestForImageAndRegister(BuildContext context,
      String userName, DateTime birthday, Map data, File? image) async {
    try {
      Map<String, String> headers = {'Accept': 'application/json'};
      var uri = Uri.parse(NetworkUtils.api_url + NetworkUtils.register);
      var request = new http.MultipartRequest("POST", uri);
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      print("URL: " + NetworkUtils.api_url + NetworkUtils.register);

      if (image != null && await image.length() != 0) {
        var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
        var length = await image.length();

        // multipart that takes file
        var multipartFileSign = new http.MultipartFile(
            'profile_image', stream, length,
            filename: image.path);

        // add file to multipart
        request.files.add(multipartFileSign);
      }

      request.headers.addAll(headers);
      String? deviceId;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        deviceId = await PlatformDeviceId.getDeviceId;

      } on PlatformException {
        deviceId = "-----------------------";
      }
      request.fields['firstname'] = data['firstname'];
      request.fields['lastname'] = data['lastname'];
      request.fields['username'] = userName;
      request.fields['birthday'] = birthday.toString();
      request.fields['email'] = data['email'];
      request.fields['password'] = data['password'];
      request.fields['fcm_token'] = fcmToken ?? '';
      request.fields['device_id'] = deviceId ?? '';

      request.fields['mobile_os'] = data['mobile_os'];
      request.fields['device_name'] = data['device_name'];

      // listen for response
      request.send().then((response) {
        response.stream.transform(utf8.decoder).listen((value) async {
          Navigator.pop(context);
          try {
            final body = json.decode(value);
            LoginModel result = new LoginModel.map(body);

            if (result.status == "true") {
              Navigator.pop(context);
              CommonUtils.successToast(context, result.message);
              CommonUtils.saveData(result, context);
            } else
              CommonUtils.errorToast(context, result.message);
          } catch (e) {
            print(e);
          }
        });
      }).catchError((e) {
        print(e);
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }
}
