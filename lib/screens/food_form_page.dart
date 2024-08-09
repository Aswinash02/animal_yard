import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  ScrollController _mainScrollController = ScrollController();

  Future<void> _onPageRefresh() async {}

  bool? _isAgree = false;
  String googleRecaptchaKey = "";
  City? _selected_city;
  Country? _selected_country;
  MyState? _selected_state;
  int? selectedTab;
  String userType = "";
  var countries_code = <String?>[];
  String? _phone = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _shopController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        displacement: 10,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                buildProfileForm(context, _screen_width)
              ]),
            )
          ],
        ),
      ),
    );
  }

  buildProfileForm(BuildContext context, screen_width) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBasicInfo(context, screen_width),
          ],
        ),
      ),
    );
  }

  buildBasicInfo(BuildContext context, _screen_width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _screen_width,
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
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  AppLocalizations.of(context)!.email_ucf,
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
                        controller: _emailController,
                        autofocus: false,
                        decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "johndoe@example.com"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "Product",
                  style: TextStyle(
                      color: MyTheme.accent_color, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 36,
                  child: TextField(
                    controller: _shopController,
                    autofocus: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "Enter Product"),
                  ),
                ),
              ),
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
                      child: CustomInternationalPhoneNumberInput(
                        countries: countries_code,
                        onInputChanged: (PhoneNumber number) {
                          print(number.phoneNumber);
                          setState(() {
                            _phone = number.phoneNumber;
                          });
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: MyTheme.font_grey),
                        textFieldController: _phoneNumberController,
                        formatInput: true,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputDecoration:
                            InputDecorations.buildInputDecoration_phone(
                                hint_text: "01XXX XXX XXX"),
                        onSaved: (PhoneNumber number) {
                          //print('On Saved: $number');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("${AppLocalizations.of(context)!.address_ucf}",
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 60,
                  child: TextField(
                    controller: _addressController,
                    autofocus: false,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: "Enter Address"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("${AppLocalizations.of(context)!.country_ucf}",
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 40,
                  child: TypeAheadField(
                    suggestionsCallback: (name) async {
                      var countryResponse =
                          await AddressRepository().getCountryList(name: name);
                      return countryResponse.countries;
                    },
                    loadingBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .loading_countries_ucf,
                                style: TextStyle(color: MyTheme.medium_grey))),
                      );
                    },
                    itemBuilder: (context, dynamic country) {
                      //print(suggestion.toString());
                      return ListTile(
                        dense: true,
                        title: Text(
                          country.name,
                          style: TextStyle(color: MyTheme.font_grey),
                        ),
                      );
                    },
                    noItemsFoundBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .no_country_available,
                                style: TextStyle(color: MyTheme.medium_grey))),
                      );
                    },
                    onSuggestionSelected: (dynamic country) {
                      onSelectCountryDuringAdd(country);
                      print("Country Data ${_countryController}");
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      onTap: () {},
                      //autofocus: true,
                      controller: _countryController,
                      onSubmitted: (txt) {
                        // keep this blank
                      },
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text:
                              AppLocalizations.of(context)!.enter_country_ucf),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "${AppLocalizations.of(context)!.state_ucf}",
                  style: TextStyle(
                      color: MyTheme.accent_color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 40,
                  child: TypeAheadField(
                    suggestionsCallback: (name) async {
                      if (_selected_country == null) {
                        var stateResponse = await AddressRepository()
                            .getStateListByCountry(); // blank response
                        return stateResponse.states;
                      }
                      var stateResponse = await AddressRepository()
                          .getStateListByCountry(
                              country_id: _selected_country!.id, name: name);
                      return stateResponse.states;
                    },
                    loadingBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.loading_states_ucf,
                            style: TextStyle(color: MyTheme.medium_grey),
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, dynamic state) {
                      //print(suggestion.toString());
                      return ListTile(
                        dense: true,
                        title: Text(
                          state.name,
                          style: TextStyle(color: MyTheme.font_grey),
                        ),
                      );
                    },
                    noItemsFoundBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .no_state_available,
                                style: TextStyle(color: MyTheme.medium_grey))),
                      );
                    },
                    onSuggestionSelected: (dynamic state) {
                      onSelectStateDuringAdd(state);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      onTap: () {},
                      //autofocus: true,
                      controller: _stateController,
                      onSubmitted: (txt) {},
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text:
                              AppLocalizations.of(context)!.enter_state_ucf),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("${AppLocalizations.of(context)!.city_ucf}",
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 40,
                  child: TypeAheadField(
                    suggestionsCallback: (name) async {
                      if (_selected_state == null) {
                        var cityResponse = await AddressRepository()
                            .getCityListByState(); // blank response
                        return cityResponse.cities;
                      }
                      var cityResponse = await AddressRepository()
                          .getCityListByState(
                              state_id: _selected_state!.id, name: name);
                      return cityResponse.cities;
                    },
                    loadingBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                            child: Text(
                                AppLocalizations.of(context)!
                                    .loading_cities_ucf,
                                style: TextStyle(color: MyTheme.medium_grey))),
                      );
                    },
                    itemBuilder: (context, dynamic city) {
                      //print(suggestion.toString());
                      return ListTile(
                        dense: true,
                        title: Text(
                          city.name,
                          style: TextStyle(color: MyTheme.medium_grey),
                        ),
                      );
                    },
                    noItemsFoundBuilder: (context) {
                      return Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.no_city_available,
                            style: TextStyle(
                              color: MyTheme.medium_grey,
                            ),
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (dynamic city) {
                      onSelectCityDuringAdd(city);
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      onTap: () {},
                      //autofocus: true,
                      controller: _cityController,
                      onSubmitted: (txt) {
                        // keep blank
                      },
                      decoration: InputDecorations.buildInputDecoration_1(
                          hint_text:
                              AppLocalizations.of(context)!.enter_city_ucf),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(AppLocalizations.of(context)!.postal_code,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  height: 40,
                  child: TextField(
                    controller: _postalCodeController,
                    autofocus: false,
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: AppLocalizations.of(context)!
                            .enter_postal_code_ucf),
                  ),
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
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      // onPressSignUpSeller();
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Food Booking",
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
