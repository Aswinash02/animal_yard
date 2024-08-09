import 'package:active_ecommerce_flutter/controllers/local_controller.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/language_repository.dart';
import 'package:active_ecommerce_flutter/repositories/coupon_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'index.dart';

class ChangeLanguage extends StatefulWidget {
  ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  var _selectedIndex = 0;
  ScrollController _mainScrollController = ScrollController();
  var _list = [];
  bool _isInitial = true;

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchList() async {
    print("Called Language List Function");
    var languageListResponse = await LanguageRepository().getLanguageList();
    _list.addAll(languageListResponse.languages!);

    var idx = 0;
    if (_list.isNotEmpty) {
      _list.forEach((lang) {
        if (lang.code == app_language.$) {
          setState(() {
            _selectedIndex = idx;
          });
        }
        idx++;
      });
    }
    _isInitial = false;
    setState(() {});
  }

  reset() {
    _list.clear();
    _isInitial = true;
    _selectedIndex = 0;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchList();
  }

  onLanguageItemTap(index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      app_language.$ = _list[_selectedIndex].code;
      app_language.save();
      app_mobile_language.$ = _list[_selectedIndex].mobile_app_code;
      app_mobile_language.save();
      app_language_rtl.$ = _list[_selectedIndex].rtl;
      app_language_rtl.save();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final LocaleController localeController = Get.find();
        localeController.setLocale(_list[_selectedIndex].mobile_app_code);

        // Navigate to Index screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Index()),
        );
      });
    }
  }

  // onLanguageItemTap(index) {
  //   if (index != _selectedIndex) {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //
  //     app_language.$ = _list[_selectedIndex].code;
  //     app_language.save();
  //     app_mobile_language.$ = _list[_selectedIndex].mobile_app_code;
  //     app_mobile_language.save();
  //     app_language_rtl.$ = _list[_selectedIndex].rtl;
  //     app_language_rtl.save();
  //
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Provider.of<LocaleProvider>(context, listen: false)
  //           .setLocale(_list[_selectedIndex].mobile_app_code);
  //
  //       // Navigate to Index screen
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => Index()),
  //       );
  //       // context.go('/');
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              displacement: 0,
              child: CustomScrollView(
                controller: _mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: buildLanguageMethodList(),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          padding: EdgeInsets.zero,
          icon: UsefulElements.backButton(context),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "${AppLocalizations.of(context)!.change_language_ucf} (${app_language.$}) - (${app_mobile_language.$})",
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildLanguageMethodList() {
    if (_isInitial && _list.isEmpty) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_list.isNotEmpty) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 14,
            );
          },
          itemCount: _list.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildLanguageMethodItemCard(index);
          },
        ),
      );
    } else if (!_isInitial && _list.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.no_language_is_added,
            style: TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    }
  }

  GestureDetector buildLanguageMethodItemCard(index) {
    return GestureDetector(
      onTap: () {
        onLanguageItemTap(index);
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            decoration: BoxDecorations.buildBoxDecoration_1().copyWith(
              border: Border.all(
                color: _selectedIndex == index
                    ? MyTheme.accent_color
                    : MyTheme.light_grey,
                width: _selectedIndex == index ? 1.0 : 0.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: _list[index].image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "${_list[index].name} - ${_list[index].code} - ${_list[index].mobile_app_code}",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          app_language_rtl.$!
              ? Positioned(
                  left: 16,
                  top: 16,
                  child: buildCheckContainer(_selectedIndex == index),
                )
              : Positioned(
                  right: 16,
                  top: 16,
                  child: buildCheckContainer(_selectedIndex == index),
                )
        ],
      ),
    );
  }

  Container buildCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.green,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(Icons.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }
}
