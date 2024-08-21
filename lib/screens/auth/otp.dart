import 'dart:convert';

import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/loading.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/screens/auth/login.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/services/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';

class Otp extends StatefulWidget {
  String? title;
  String? phone;

  Otp({Key? key, this.title, this.phone}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  onTapResend() async {
    Loading.show(context);
    var resendCodeResponse = await AuthRepository().getResendCodeResponse();
    Loading.close();
    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message!,
          gravity: Toast.center, duration: Toast.lengthLong);
    }
  }

  onPressConfirm() async {
    var code = _verificationCodeController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_verification_code,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    Loading.show(context);
    var confirmCodeResponse =
        await AuthRepository().getConfirmCodeResponse(code, widget.phone!);
    Loading.close();
    if (confirmCodeResponse.result == false) {
      ToastComponent.showDialog(confirmCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(confirmCodeResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);

      if (SystemConfig.systemUser != null) {
        SystemConfig.systemUser!.emailVerified = true;
      }
      AuthHelper().setUserData(confirmCodeResponse);
      SharedPreference().setUserData(jsonEncode(confirmCodeResponse));
      SharedPreference().setLogin(true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: _screen_width * (3 / 4),
                child: Image.asset(
                    "assets/splash_login_registration_background_image.png"),
              ),
              Container(
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.title != null)
                      Text(
                        widget.title!,
                        style:
                            TextStyle(fontSize: 25, color: MyTheme.font_grey),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                      child: Container(
                        width: 75,
                        height: 75,
                        child: Image.asset(
                            'assets/login_registration_form_logo.png'),
                      ),
                    ),
                    Container(
                      width: _screen_width * (3 / 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 36,
                                  child: TextField(
                                    controller: _verificationCodeController,
                                    autofocus: false,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (String str) {
                                      if (str.length == 6) {
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                    decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text: "A X B 4 J H"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyTheme.textfield_grey, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Btn.basic(
                                minWidth: MediaQuery.of(context).size.width,
                                color: MyTheme.accent_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12.0))),
                                child: Text(
                                  AppLocalizations.of(context)!.confirm_ucf,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  onPressConfirm();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: InkWell(
                        onTap: () {
                          onTapResend();
                        },
                        child: Text(
                            AppLocalizations.of(context)!.resend_code_ucf,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                decoration: TextDecoration.underline,
                                fontSize: 13)),
                      ),
                    ),
                    // SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: InkWell(
                        onTap: () {
                          onTapLogout(context);
                        },
                        child: Text(AppLocalizations.of(context)!.logout_ucf,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                decoration: TextDecoration.underline,
                                fontSize: 13)),
                      ),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  onTapLogout(context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
