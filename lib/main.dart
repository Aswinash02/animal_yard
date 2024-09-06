import 'dart:async';

import 'package:active_ecommerce_flutter/common/no_internet_screen.dart';
import 'package:active_ecommerce_flutter/controllers/chat_controller.dart';
import 'package:active_ecommerce_flutter/controllers/local_controller.dart';
import 'package:active_ecommerce_flutter/custom/aiz_route.dart';
import 'package:active_ecommerce_flutter/firebase_options.dart';
import 'package:active_ecommerce_flutter/helpers/main_helpers.dart';
import 'package:active_ecommerce_flutter/middlewares/auth_middleware.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/presenter/currency_presenter.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/repositories/firebase_repository.dart';
import 'package:active_ecommerce_flutter/screens/all_routes.dart';
import 'package:active_ecommerce_flutter/screens/auction/auction_bidded_products.dart';
import 'package:active_ecommerce_flutter/screens/auction/auction_products.dart';
import 'package:active_ecommerce_flutter/screens/auction/auction_products_details.dart';
import 'package:active_ecommerce_flutter/screens/auction/auction_purchase_history.dart';
import 'package:active_ecommerce_flutter/screens/auth/login.dart';
import 'package:active_ecommerce_flutter/screens/auth/registration.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list_n_product/category_list.dart';
import 'package:active_ecommerce_flutter/screens/category_list_n_product/category_products.dart';
import 'package:active_ecommerce_flutter/screens/coupon/coupons.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal/flash_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/followed_sellers.dart';
import 'package:active_ecommerce_flutter/screens/index.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/orders/order_details.dart';
import 'package:active_ecommerce_flutter/screens/orders/order_list.dart';
import 'package:active_ecommerce_flutter/screens/package/packages.dart';
import 'package:active_ecommerce_flutter/screens/product/product_details.dart';
import 'package:active_ecommerce_flutter/screens/product/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:active_ecommerce_flutter/screens/splash_screen.dart';
import 'package:active_ecommerce_flutter/services/local_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:shared_value/shared_value.dart';
import 'package:get/get.dart';
import 'app_config.dart';

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('message id ${message.messageId}');
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneContext().key = GlobalKey<NavigatorState>();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  FirebaseRepository firebaseRepo = FirebaseRepository();
  firebaseRepo.requestPermission();
  var token = await firebaseRepo.getToken();
  print('device token $token');

  SharedPreference().setDeviceToken(token);
  // firebaseRepo.sendPushNotification(token,"test");
  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

var routes = GoRouter(
  overridePlatformDefaultLocation: false,
  navigatorKey: OneContext().key,
  initialLocation: "/",
  routes: [
    GoRoute(
        path: '/',
        name: "Home",
        pageBuilder: (BuildContext context, GoRouterState state) =>
            MaterialPage(child: SplashScreen()),
        routes: [
          GoRoute(
              path: "customer_products",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: MyClassifiedAds())),
          GoRoute(
              path: "no_internet",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: NoInternetScreen())),
          GoRoute(
              path: "initial",
              name: "main",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: Main())),
          GoRoute(
              path: "customer-products",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: ClassifiedAds())),
          GoRoute(
              path: "customer-product/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: ClassifiedAdsDetails(
                    slug: getParameter(state, "slug"),
                  ))),
          GoRoute(
              path: "product/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: ProductDetails(
                    slug: getParameter(state, "slug"),
                  ))),
          GoRoute(
              path: "customer-packages",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: UpdatePackage())),
          GoRoute(
              path: "auction_product_bids",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: AuthMiddleware(AuctionBiddedProducts()).next())),
          GoRoute(
              path: "users/login",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: Login())),
          GoRoute(
              path: "users/registration",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: Registration())),
          GoRoute(
              path: "dashboard",
              name: "Profile",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  AIZRoute.rightTransition(Profile())),
          GoRoute(
              path: "auction-products",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: AuctionProducts())),
          GoRoute(
              path: "auction-product/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: AuctionProductsDetails(
                    slug: getParameter(state, "slug"),
                  ))),
          GoRoute(
              path: "auction/purchase_history",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: AuthMiddleware(AuctionPurchaseHistory()).next())),
          GoRoute(
              path: "brand/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (BrandProducts(
                    slug: getParameter(state, "slug"),
                  )))),
          // GoRoute(
          // path: "brands",
          // name: "Brands",
          // pageBuilder: (BuildContext context, GoRouterState state) =>
          //     MaterialPage(
          //         child: Filter(
          //       selected_filter: "brands",
          //     ))),
          GoRoute(
              path: "cart",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: AuthMiddleware(Cart()).next())),
          GoRoute(
              path: "categories",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (CategoryList(
                    slug: getParameter(state, "slug"),
                    digital: 1,
                  )))),
          GoRoute(
              path: "category/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (CategoryProducts(
                    slug: getParameter(state, "slug"),
                  )))),
          GoRoute(
              path: "flash-deals",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (FlashDealList()))),
          GoRoute(
              path: "flash-deal/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (FlashDealProducts(
                    slug: getParameter(state, "slug"),
                  )))),
          GoRoute(
              path: "followed-seller",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (FollowedSellers()))),
          GoRoute(
              path: "purchase_history",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (OrderList()))),
          GoRoute(
              path: "purchase_history/details/:id",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (OrderDetails(
                    id: int.parse(getParameter(state, "id")),
                  )))),
          // GoRoute(
          //     path: "sellers",
          //     pageBuilder: (BuildContext context, GoRouterState state) =>
          //         MaterialPage(
          //             child: (Filter(
          //           selected_filter: "sellers",
          //         )))),
          GoRoute(
              path: "shop/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (SellerDetails(
                    slug: getParameter(state, "slug"),
                  )))),
          GoRoute(
              path: "todays-deal",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (TodaysDealProducts()))),
          GoRoute(
              path: "coupons",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (Coupons()))),
        ])
  ],
);

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    routes.routerDelegate.addListener(() {});
    routes.routeInformationProvider.addListener(() {});
    super.initState();
  }
  FirebaseRepository firebaseRepo = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    firebaseRepo.initInfo(context);
    final textTheme = Theme.of(context).textTheme;
    final LocaleController localeController = Get.put(LocaleController());
    Get.put(ChatController());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartCounter()),
        ChangeNotifierProvider(create: (context) => CurrencyPresenter()),
      ],
      child: Consumer<CartCounter>(
        builder: (context, provider, snapshot) {
          return Obx(
            () => GetMaterialApp.router(
              locale: localeController.locale.value,
              builder: (context, child) => OneContext().builder(
                context,
                child,
                onGenerateRoute: (route) {
                  return MaterialPageRoute(builder: (context2) {
                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: Builder(
                        builder: (innerContext) {
                          OneContext().context = innerContext;
                          return child!;
                        },
                      ),
                    );
                  });
                },
                onUnknownRoute: (route) {
                  return MaterialPageRoute(builder: (context) => child!);
                },
              ),
              routeInformationParser: routes.routeInformationParser,
              routerDelegate: routes.routerDelegate,
              routeInformationProvider: routes.routeInformationProvider,
              title: AppConfig.app_name,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: MyTheme.white,
                scaffoldBackgroundColor: MyTheme.white,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: "PublicSansSerif",
                textTheme: MyTheme.textTheme1,
                fontFamilyFallback: ['NotoSans'],
              ),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', ''), // English
                Locale('ta', ''), // Tamil
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale?.languageCode &&
                      locale.countryCode == deviceLocale?.countryCode) {
                    return localeController.locale.value;
                  }
                }
                return supportedLocales.first;
              },
            ),
          );
        },
      ),
    );
  }
}
