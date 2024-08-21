import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/screens/auth/otp.dart';
import 'package:active_ecommerce_flutter/screens/auth/password_forget.dart';
import 'package:active_ecommerce_flutter/screens/auth/registration.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/services/local_db.dart';
import 'package:active_ecommerce_flutter/social_config.dart';
import 'package:active_ecommerce_flutter/ui_elements/auth_ui.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:toast/toast.dart';
import 'package:twitter_login/twitter_login.dart';

import '../../custom/loading.dart';
import '../../repositories/address_repository.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "phone"; //phone or email
  String initialCountry = 'US';

  var countries_code = <String?>[];


  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch_country();
  }

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries.forEach((c) => countries_code.add(c.code));
  }

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var phone = _phoneNumberController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_email,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_login_by == 'phone' && phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    Loading.show(context);
    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : phone, _login_by);
    Loading.close();
    temp_user_id.$ = "";
    temp_user_id.save();

    if (loginResponse.result == true) {
      ToastComponent.showDialog(loginResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Otp(
          title: 'Verify your phone Number',
          phone: phone,
        );
      }));
      _phoneNumberController.clear();
    } else {
      if (loginResponse.message.runtimeType == List) {
        ToastComponent.showDialog(loginResponse.message!.join("\n"),
            gravity: Toast.center, duration: 3);
        return;
      }
      ToastComponent.showDialog(loginResponse.message!.toString(),
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context,
        "${AppLocalizations.of(context)!.login_to} " + AppConfig.app_name,
        buildBody(context, _screen_width));
  }

  Widget buildBody(BuildContext context, double _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "Phone",
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 36,
                      child: TextField(
                        controller: _phoneNumberController,
                        autofocus: false,
                        onChanged: (String? str) {
                          if (str!.length == 10) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "01XXX XXX XXX"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyTheme.textfield_grey, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Btn.minWidthFixHeight(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0))),
                    child: Text(
                      AppLocalizations.of(context)!.login_screen_log_in,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      onPressedLogin();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                child: Center(
                    child: Text(
                  AppLocalizations.of(context)!
                      .login_screen_or_create_new_account,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
                )),
              ),
              Container(
                height: 45,
                child: Btn.minWidthFixHeight(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50,
                  color: MyTheme.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0))),
                  child: Text(
                    AppLocalizations.of(context)!.login_screen_sign_up,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Registration();
                    }));
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
