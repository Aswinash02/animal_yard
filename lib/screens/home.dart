import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/common/custom_app_bar.dart';
import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/controllers/location_controller.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/home_all_products_2.dart';
import 'package:active_ecommerce_flutter/custom/home_search_box.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list_n_product/category_products.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/product/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_sellers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'change_language.dart';

class Home extends StatefulWidget {
  Home({
    Key? key,
    this.title,
    this.show_back_button = false,
    go_back = true,
  }) : super(key: key);

  final String? title;
  bool show_back_button;
  late bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  HomePresenter homeData = HomePresenter();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      change();
    });
    // TODO: implement initState
    super.initState();
  }

  change() {
    homeData.onRefresh();
    homeData.mainScrollListener();
    homeData.initPiratedAnimation(this);
  }

  @override
  void dispose() {
    homeData.pirated_logo_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
              title: AppConfig.app_name,
              leading: Image.asset(
                "assets/splash_screen_logo.png",
                filterQuality: FilterQuality.low,
              ),
              actions: [
                InkWell(
                  child: CustomIcon(
                    icon: "assets/world_image.png",
                    color: MyTheme.accent_color,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChangeLanguage();
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: MyTheme.accent_color,
                      borderRadius: BorderRadius.circular(10),
                      padding: EdgeInsets.all(4),
                    ),
                    badgeAnimation: badges.BadgeAnimation.slide(
                      toAnimate: false,
                    ),
                    child: CustomIcon(
                        icon: "assets/cart.png", color: MyTheme.accent_color),
                    badgeContent: Consumer<CartCounter>(
                      builder: (context, cart, child) {
                        return Text(
                          "${cart.cartCounter}",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Cart(
                        has_bottomnav: false,
                        counter: CartCounter(),
                      );
                    }));
                  },
                ),
                SizedBox(width: 8),
              ],
            ),
            body: ListenableBuilder(
                listenable: homeData,
                builder: (context, child) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        color: MyTheme.accent_color,
                        backgroundColor: Colors.white,
                        onRefresh: homeData.onRefresh,
                        displacement: 0,
                        child: CustomScrollView(
                          controller: homeData.mainScrollController,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate([
                                AppConfig.purchase_code == ""
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          9.0,
                                          16.0,
                                          9.0,
                                          0.0,
                                        ),
                                        child: Container(
                                          height: 140,
                                          color: Colors.black,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  left: 20,
                                                  top: 0,
                                                  child: AnimatedBuilder(
                                                      animation: homeData
                                                          .pirated_logo_animation,
                                                      builder:
                                                          (context, child) {
                                                        return Image.asset(
                                                          "assets/pirated_square.png",
                                                          height: homeData
                                                              .pirated_logo_animation
                                                              .value,
                                                          color: Colors.white,
                                                        );
                                                      })),
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 24.0,
                                                          left: 24,
                                                          right: 24),
                                                  child: Text(
                                                    LangText(context)
                                                        .local
                                                        .pirated_app,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                homeData.loadingState
                                    ? ShimmerHelper()
                                        .buildBasicShimmer(height: 150)
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 15),
                                        child: InkWell(
                                          child: Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/placeholder_rectangle.png',
                                                    image: homeData
                                                        .foodBannerImage!,
                                                    fit: BoxFit.cover,
                                                  ).image,
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return CategoryProducts(
                                                      slug: homeData.foodSlug ??
                                                          '',
                                                      isFood: true);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ]),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .categories,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                // ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 80,
                                child: buildHomeFeaturedCategories(
                                    context, homeData),
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: GetBuilder<LocationController>(
                              init: LocationController(),
                              builder: (controller) {
                                return controller.getAddress.value != ''
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10.0, right: 15, left: 15),
                                        child: Card(
                                          child: Container(
                                            height: 50,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_sharp,
                                                    color: MyTheme.accent_color,
                                                  ),
                                                  Text(
                                                      '${controller.getAddress.value}',
                                                      style: TextStyle(
                                                          color: MyTheme
                                                              .accent_color,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox();
                              },
                            )),
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      18.0, 18.0, 20.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .all_products_ucf,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                HomeAllProducts2(
                                  context: context,
                                  homeData: homeData,
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  Widget buildHomeFeaturedCategories(context, HomePresenter homeData) {
    return Container(
      height: 100,
      width: 150,
      child: homeData.featuredCategoryList.isEmpty
          ? Center(child: Text("No frequently bought Featured Categories"))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: homeData.featuredCategoryList.length,
              itemBuilder: (context, index) {
                final data = homeData.featuredCategoryList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CategoryProducts(
                            slug: data.slug,
                          );
                        }));
                      },
                      child: categoryContainer(data)),
                );
              }),
    );
  }

  Widget categoryContainer(Category data) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          color: MyTheme.iconContainerColor,
          borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          categoryProfileContainer(img: data),
          SizedBox(width: 5),
          Expanded(
              child: CustomText(
            text: data.name!,
            maxLines: 2,
            fontWeight: FontWeight.w600,
          ))
        ],
      ),
    );
  }
}

Widget categoryProfileContainer({required Category img}) {
  return Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: FadeInImage(
          placeholder: AssetImage('assets/placeholder_rectangle.png'),
          image: NetworkImage(img.banner ?? ''),
          fit: BoxFit.fill,
        ).image,
      ),
    ),
  );
}

Widget profileContainer({String? img, onTap}) {
  return InkWell(
    child: Image.asset(
      "assets/world_image.png",
      height: 14,
      width: 14,
      color: MyTheme.textfield_grey,
    ),
    onTap: onTap,
  );
}

class CustomIcon extends StatelessWidget {
  final double? height;
  final double? width;
  final String icon;
  final Color? color;

  const CustomIcon(
      {super.key, this.height, this.width, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 18,
      width: width ?? 16,
      child: Image(
        image: AssetImage(icon),
        color: color ?? Colors.black,
      ),
    );
  }
}
