import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/screens/auth/login.dart';
import 'package:active_ecommerce_flutter/screens/index.dart';
import 'package:active_ecommerce_flutter/ui_elements/auth_ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';

import '../../custom/loading.dart';
import '../../repositories/address_repository.dart';
import 'otp.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  String _register_by = "phone"; //phone or email
  String initialCountry = 'US';

  var countries_code = <String?>[];

  String? _phone = "";

  String googleRecaptchaKey = "";
  City? _selected_city;
  Country? _selected_country;
  MyState? _selected_state;
  int? selectedTab;
  String userType = "";

  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    fetch_country();
  }

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries.forEach((c) => countries_code.add(c.code));
  }

  onSelectCountryDuringAdd(country) {
    if (_selected_country != null && country.id == _selected_country!.id) {
      setState(() {
        _countryController.text = country.name;
      });
      return;
    }
    _selected_country = country;
    _selected_state = null;
    _selected_city = null;
    setState(() {});

    setState(() {
      _countryController.text = country.name;
      _stateController.text = "";
      _cityController.text = "";
    });
  }

  onSelectStateDuringAdd(state) {
    if (_selected_state != null && state.id == _selected_state!.id) {
      setState(() {
        _stateController.text = state.name;
      });
      return;
    }
    _selected_state = state;
    _selected_city = null;
    setState(() {});
    setState(() {
      _stateController.text = state.name;
      _cityController.text = "";
    });
  }

  onSelectCityDuringAdd(city) {
    if (_selected_city != null && city.id == _selected_city!.id) {
      setState(() {
        _cityController.text = city.name;
      });
      return;
    }
    _selected_city = city;
    setState(() {
      _cityController.text = city.name;
    });
  }

  clearFields() {
    setState(() {
      _nameController.clear();
      _phoneNumberController.clear();
      _emailController.clear();
      _addressController.clear();
      _countryController.clear();
      _stateController.clear();
      _cityController.clear();
      _postalCodeController.clear();
      _passwordController.clear();
      _passwordConfirmController.clear();
    });
  }


  onPressSignUpSeller() async {
    var name = _nameController.text.toString();
    var phone = _phoneNumberController.text.toString();

    if (name == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_your_name,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    } else if (_register_by == 'phone' && phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_phone_number,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }
    Loading.show(context);

    var signupResponse = await AuthRepository().getSignupResponseSeller(
      name,
      _register_by == 'email' ? '' : phone,
      _register_by,
      "seller",
      phone,
    );
    Loading.close();

    if (signupResponse.result == false) {
      var message = "";
      signupResponse.message.forEach((value) {
        message += value + "\n";
      });

      ToastComponent.showDialog(message, gravity: Toast.center, duration: 3);
    } else {
      ToastComponent.showDialog(signupResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      AuthHelper().setUserData(signupResponse);
      if ((mail_verification_status.$ && _register_by == "email") ||
          _register_by == "phone") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Otp(
            title: 'Verify your phone Number',
            phone: phone,
          );
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Login();
        }));
      }
      _nameController.clear();
      _phoneNumberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_width = MediaQuery.of(context).size.width;
    return AuthScreen.buildScreen(
        context,
        "${AppLocalizations.of(context)!.join_ucf} " + AppConfig.app_name,
        buildBodySeller(context, _screen_width));
  }

  Widget buildBodySeller(BuildContext context, double _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  AppLocalizations.of(context)!.name_ucf,
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 36,
                  child: TextField(
                    controller: _nameController,
                    autofocus: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "John Doe"),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      // Allow only letters and spaces
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  AppLocalizations.of(context)!.phone_ucf,
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
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (String str) {
                          if (str.length == 10) {
                            FocusScope.of(context).unfocus();
                          }
                        },
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
                  child: Btn.minWidthFixHeight(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 50,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Text(
                        AppLocalizations.of(context)!.sign_up_ucf,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressSignUpSeller();
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text(
                      AppLocalizations.of(context)!.already_have_an_account,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Text(
                        AppLocalizations.of(context)!.log_in,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return Login();
                        // }));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
