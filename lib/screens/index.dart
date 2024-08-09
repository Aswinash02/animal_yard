// import 'package:active_ecommerce_flutter/helpers/addons_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/business_setting_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
// import 'package:active_ecommerce_flutter/helpers/system_config.dart';
// import 'package:active_ecommerce_flutter/presenter/currency_presenter.dart';
// import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
// import 'package:active_ecommerce_flutter/screens/auth/login.dart';
// import 'package:active_ecommerce_flutter/screens/main.dart';
// import 'package:active_ecommerce_flutter/screens/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class Index extends StatefulWidget {
//   Index({super.key, this.goBack = true});
//
//   bool? goBack;
//
//   @override
//   State<Index> createState() => _IndexState();
// }
//
// class _IndexState extends State<Index> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemConfig.context ??= context;
//     return Scaffold(body: SplashScreen()
//         );
//   }
// }
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/controllers/local_controller.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/screens/auth/login.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

// class Index extends StatefulWidget {
//   const Index({Key? key}) : super(key: key);
//
//   @override
//   State<Index> createState() => _IndexState();
// }
//
// class _IndexState extends State<Index> {
//   PackageInfo _packageInfo = PackageInfo(
//     appName: AppConfig.app_name,
//     packageName: 'Unknown',
//     version: 'Unknown',
//     buildNumber: 'Unknown',
//   );
//
//   Future<void> _initPackageInfo() async {
//     final PackageInfo info = await PackageInfo.fromPlatform();
//     setState(() {
//       _packageInfo = info;
//     });
//   }
//
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   _initPackageInfo();
//   // }
//
//   @override
//   void initState() {
//     print(
//         "getting Mobile Language============================>${app_mobile_language.$}");
//     super.initState();
//     _initPackageInfo();
//     getSharedValueHelperData().then((value) {
//       Provider.of<LocaleProvider>(context, listen: false)
//           .setLocale(app_mobile_language.$!);
//       setState(() {});
//       Future.delayed(const Duration(seconds: 2)).then((value) {
//         if (is_logged_in.$) {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => Main()));
//           // context.replace('/initial');
//         } else {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => Login()));
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: splashScreen());
//   }
//
//   Widget splashScreen() {
//     return Container(
//       width: DeviceInfo(context).height,
//       height: DeviceInfo(context).height,
//       color: MyTheme.splash_screen_color,
//       child: InkWell(
//         child: Stack(
//           // mainAxisAlignment: MainAxisAlignment.start,
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             CircleAvatar(
//               backgroundColor: Colors.transparent,
//               child: Hero(
//                 tag: "backgroundImageInSplash",
//                 child: Container(
//                   child: Image.asset(
//                       "assets/splash_login_registration_background_image.png"),
//                 ),
//               ),
//               radius: 140.0,
//             ),
//             Positioned.fill(
//               top: DeviceInfo(context).height! / 2 - 72,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10.0),
//                     child: Hero(
//                       tag: "splashscreenImage",
//                       child: Container(
//                         height: 72,
//                         width: 72,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                         decoration: BoxDecoration(
//                             color: MyTheme.white,
//                             borderRadius: BorderRadius.circular(8)),
//                         child: Image.asset(
//                           "assets/splash_screen_logo.png",
//                           filterQuality: FilterQuality.low,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 5.0),
//                     child: Text(
//                       AppConfig.app_name,
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14.0,
//                           color: Colors.white),
//                     ),
//                   ),
//                   Text(
//                     "V " + _packageInfo.version,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 51.0),
//                   child: Text(
//                     AppConfig.copyright_text,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w400,
//                       fontSize: 13.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
// /*
//             Padding(
//               padding: const EdgeInsets.only(top: 120.0),
//               child: Container(
//                   width: double.infinity,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//
//                     ],
//                   )),
//             ),*/
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<String?> getSharedValueHelperData() async {
//     access_token.load().whenComplete(() {
//       AuthHelper().fetch_and_set();
//     });
//     await app_language.load();
//     await app_mobile_language.load();
//     await app_language_rtl.load();
//     await system_currency.load();
//     return app_mobile_language.$;
//   }
// }
import 'package:active_ecommerce_flutter/helpers/addons_helper.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/business_setting_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/presenter/currency_presenter.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Index extends StatefulWidget {
  Index({super.key, this.goBack = true});

  bool? goBack;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final LocaleController localeController = Get.put(LocaleController());

  Future<String?> getSharedValueHelperData() async {
    await app_language.load();
    await app_mobile_language.load();
    await app_language_rtl.load();
    await system_currency.load();
    Provider.of<CurrencyPresenter>(context, listen: false).fetchListData();
    return app_mobile_language.$;
  }

  @override
  void initState() {
    super.initState();
    getSharedValueHelperData().then((value) {
      Future.delayed(Duration(seconds: 3)).then((_) {
        print(
            "getting mobile language----------------->${app_mobile_language.$!}");
        SystemConfig.isShownSplashScreed = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Provider.of<LocaleProvider>(context, listen: false)
          //     .setLocale(app_mobile_language.$!);
          localeController.setLocale(app_mobile_language.$!);
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemConfig.context ??= context;
    return Scaffold(
      body: SystemConfig.isShownSplashScreed ? Main() : SplashScreen(),
    );
  }
}
