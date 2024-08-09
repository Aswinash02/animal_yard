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
import 'package:active_ecommerce_flutter/screens/category_list_n_product/category_list.dart';
import 'package:active_ecommerce_flutter/screens/category_list_n_product/category_products.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/product/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_sellers.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    // change();
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
    //  ChangeNotifierProvider<HomePresenter>.value(value: value)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // final localeProvider = Provider.of<LocaleProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
              //key: homeData.scaffoldKey,
              appBar: CustomAppBar(
                title: AppConfig.app_name,
                // title: localeProvider.locale.languageCode,
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
                  // InkWell(
                  //     child: CustomIcon(
                  //       icon: Icon(
                  //         AppIcons.favoriteIcon,
                  //         color: MyTheme.accent_color,
                  //       ),
                  //       color: MyTheme.accent_color,
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) {
                  //         return Wishlist();
                  //       }));
                  //     }),
                  SizedBox(width: 8),
                  // CustomIcon(
                  //   icon: Icon(AppIcons.notificationIcon,
                  //       color: MyTheme.blackColor),
                  //   color: MyTheme.blackColor,
                  // ),
                ],
              ),
              // PreferredSize(
              //   preferredSize: Size.fromHeight(50),
              //   child: buildAppBar(statusBarHeight, context),
              // ),
              //drawer: MainDrawer(),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 15),
                                    child: HomeSearchBox(context: context),
                                  ),
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
                                                    image: NetworkImage(homeData
                                                            .foodBannerImage ??
                                                        ''),
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                            onTap: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) {
                                              //       return CategoryList(
                                              //         slug: "",
                                              //         is_base_category: true,
                                              //         digital: 0,
                                              //       );
                                              //     },
                                              //   ),
                                              // );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return CategoryProducts(
                                                      slug: "Food-8H3YG",
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                  // HomeCarouselSlider(
                                  //     context: context, homeData: homeData),
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
                                              .featured_categories,
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
                                              bottom: 10.0,
                                              right: 15,
                                              left: 15),
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
                                                      color:
                                                          MyTheme.accent_color,
                                                    ),
                                                    Text(
                                                        '${controller.getAddress.value}',
                                                        style: TextStyle(
                                                            color: MyTheme
                                                                .accent_color,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox();
                                },
                              )),
                              // SliverToBoxAdapter(
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //         right: 15.0, left: 15, bottom: 12),
                              //     child: Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Row(
                              //           children: [
                              //             Text(
                              //               "Food Categories",
                              //               style: TextStyle(
                              //                   fontSize: 18,
                              //                   fontWeight: FontWeight.w700),
                              //             ),
                              //             Spacer(),
                              //             GestureDetector(
                              //               onTap: () {
                              //                 Navigator.push(
                              //                   context,
                              //                   MaterialPageRoute(
                              //                     builder: (context) {
                              //                       return CategoryList(
                              //                         slug: "",
                              //                         is_base_category: true,
                              //                         digital: 0,
                              //                       );
                              //                     },
                              //                   ),
                              //                 );
                              //               },
                              //               child: SizedBox(
                              //                   height: 30,
                              //                   width: 30,
                              //                   child: Icon(
                              //                       Icons.arrow_forward_ios)),
                              //             )
                              //           ],
                              //         ),
                              //         SizedBox(
                              //           height: 8,
                              //         ),
                              //         homeData.loadingState
                              //             ? ShimmerHelper()
                              //                 .buildBasicShimmer(height: 150)
                              //             : InkWell(
                              //                 child: Container(
                              //                   height: 150,
                              //                   decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.circular(20),
                              //                     image: DecorationImage(
                              //                         image: NetworkImage(
                              //                             homeData
                              //                                 .foodBannerImage!),
                              //                         fit: BoxFit.fill),
                              //                   ),
                              //                 ),
                              //                 onTap: () {
                              //                   Navigator.push(
                              //                     context,
                              //                     MaterialPageRoute(
                              //                       builder: (context) {
                              //                         return CategoryList(
                              //                           slug: "",
                              //                           is_base_category: true,
                              //                           digital: 0,
                              //                         );
                              //                       },
                              //                     ),
                              //                   );
                              //                 },
                              //               ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // SliverToBoxAdapter(
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //         right: 15.0, left: 15, bottom: 12),
                              //     child: Stack(
                              //       children: [
                              //         Container(
                              //           height: 150,
                              //           decoration: BoxDecoration(
                              //             image: DecorationImage(
                              //                 image: AssetImage(
                              //                     "assets/food_image.png"),
                              //                 fit: BoxFit.fill),
                              //           ),
                              //         ),
                              //         Positioned(
                              //             bottom: 10,
                              //             right: 10,
                              //             child: InkWell(
                              //               onTap: () {
                              //                 Navigator.push(
                              //                   context,
                              //                   MaterialPageRoute(
                              //                     builder: (context) {
                              //                       return ProductForm();
                              //                     },
                              //                   ),
                              //                 );
                              //               },
                              //               child: Container(
                              //                 padding: EdgeInsets.symmetric(
                              //                     horizontal: 10, vertical: 5),
                              //                 child: Text(
                              //                   "Book Now",
                              //                   style: TextStyle(
                              //                       color: Colors.white,
                              //                       fontWeight: FontWeight.bold,
                              //                       fontSize: 16),
                              //                 ),
                              //                 decoration: BoxDecoration(
                              //                     color: MyTheme.accent_color,
                              //                     borderRadius:
                              //                         BorderRadius.circular(5)),
                              //               ),
                              //             ))
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Container(
                                    color: MyTheme.accent_color,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 180,
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                  "assets/background_1.png")
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  right: 18.0,
                                                  left: 18.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .featured_products_ucf,
                                                // localeProvider.locale.languageCode,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            buildHomeFeatureProductHorizontalList(
                                                homeData)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                              // SliverList(
                              //   delegate: SliverChildListDelegate(
                              //     [
                              //       HomeBannerTwo(
                              //           context: context, homeData: homeData),
                              //     ],
                              //   ),
                              // ),
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      18.0,
                                      18.0,
                                      20.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .all_products_ucf,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 10),
                                          child: Container(
                                            height: 200,
                                            child: HomeAllProducts2(
                                                context: context,
                                                homeData: homeData),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),

                              SliverList(
                                delegate: SliverChildListDelegate([
                                  Container(
                                    color: MyTheme.accent_color,
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 180,
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Image.asset(
                                                  "assets/background_1.png")
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  right: 18.0,
                                                  left: 18.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .best_selling_ucf,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            buildHomeBestSellingProductHorizontalList(
                                                homeData)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        // Align(
                        //     alignment: Alignment.center,
                        //     child: buildProductLoadingContainer(homeData))
                      ],
                    );
                  })),
        ),
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
                            // category_name: homeData.featuredCategoryList[index].name,
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

  // Widget buildHomeFeaturedCategories(context, HomePresenter homeData) {
  //   if (homeData.isCategoryInitial &&
  //       homeData.featuredCategoryList.length == 0) {
  //     return ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
  //         crossAxisSpacing: 14.0,
  //         mainAxisSpacing: 14.0,
  //         item_count: 10,
  //         mainAxisExtent: 170.0,
  //         controller: homeData.featuredCategoryScrollController);
  //   } else if (homeData.featuredCategoryList.length > 0) {
  //     //snapshot.hasData
  //     return GridView.builder(
  //         padding:
  //         const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
  //         scrollDirection: Axis.horizontal,
  //         controller: homeData.featuredCategoryScrollController,
  //         itemCount: homeData.featuredCategoryList.length,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             childAspectRatio: 3 / 2,
  //             crossAxisSpacing: 14,
  //             mainAxisSpacing: 14,
  //             mainAxisExtent: 170.0),
  //         itemBuilder: (context, index) {
  //           return GestureDetector(
  //             onTap: () {
  //               Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                 return CategoryProducts(
  //                   slug: homeData.featuredCategoryList[index].slug,
  //                   // category_name: homeData.featuredCategoryList[index].name,
  //                 );
  //               }));
  //             },
  //             child: Container(
  //               decoration: BoxDecorations.buildBoxDecoration_1(),
  //               child: Row(
  //                 children: <Widget>[
  //                   Container(
  //                       child: ClipRRect(
  //                           borderRadius: BorderRadius.horizontal(
  //                               left: Radius.circular(6), right: Radius.zero),
  //                           child: FadeInImage.assetNetwork(
  //                             placeholder: 'assets/placeholder.png',
  //                             image:
  //                             homeData.featuredCategoryList[index].banner,
  //                             fit: BoxFit.cover,
  //                           ))),
  //                   Flexible(
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Text(
  //                         homeData.featuredCategoryList[index].name,
  //                         textAlign: TextAlign.left,
  //                         overflow: TextOverflow.ellipsis,
  //                         maxLines: 3,
  //                         softWrap: true,
  //                         style:
  //                         TextStyle(fontSize: 12, color: MyTheme.font_grey),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //   } else if (!homeData.isCategoryInitial &&
  //       homeData.featuredCategoryList.length == 0) {
  //     return Container(
  //         height: 100,
  //         child: Center(
  //             child: Text(
  //               AppLocalizations.of(context)!.no_category_found,
  //               style: TextStyle(color: MyTheme.font_grey),
  //             )));
  //   } else {
  //     // should not be happening
  //     return Container(
  //       height: 100,
  //     );
  //   }
  // }

  Widget buildHomeFeatureProductHorizontalList(HomePresenter homeData) {
    if (homeData.isFeaturedProductInitial == true &&
        homeData.featuredProductList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 160) / 3)),
        ],
      );
    } else if (homeData.featuredProductList.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 248,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                homeData.fetchFeaturedProducts();
              }
              return true;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(18.0),
              separatorBuilder: (context, index) => SizedBox(
                width: 14,
              ),
              itemCount: homeData.totalFeaturedProductData! >
                      homeData.featuredProductList.length
                  ? homeData.featuredProductList.length + 1
                  : homeData.featuredProductList.length,
              scrollDirection: Axis.horizontal,
              //itemExtent: 135,

              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return (index == homeData.featuredProductList.length)
                    ? SpinKitFadingFour(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    : ProductCard(product: homeData.featuredProductList[index]);
              },
            ),
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_related_product,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  Widget buildHomeBestSellingProductHorizontalList(HomePresenter homeData) {
    if (homeData.isBestSellingProductInitial == true &&
        homeData.bestSellingProductList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 160) / 3)),
        ],
      );
    } else if (homeData.bestSellingProductList.length > 0) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 248,
          child: ListView.separated(
            padding: const EdgeInsets.all(18.0),
            separatorBuilder: (context, index) => SizedBox(
              width: 14,
            ),
            itemCount: homeData.bestSellingProductList.length,
            // homeData.totalBestSellingProductData! >
            //         homeData.bestSellingProductList.length
            //     ? homeData.bestSellingProductList.length + 1
            //     : homeData.bestSellingProductList.length,
            scrollDirection: Axis.horizontal,
            //itemExtent: 135,

            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              return (index == homeData.bestSellingProductList.length)
                  ? SpinKitFadingFour(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  : ProductCard(
                      product: homeData.bestSellingProductList[index]);
            },
          ),
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.no_related_product,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  Widget buildHomeMenuRow1(BuildContext context, HomePresenter homeData) {
    return Row(
      children: [
        if (homeData.isTodayDeal)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TodaysDealProducts();
                }));
              },
              child: Container(
                height: 90,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/todays_deal.png")),
                    ),
                    Text(AppLocalizations.of(context)!.todays_deal_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          ),
        if (homeData.isTodayDeal && homeData.isFlashDeal) SizedBox(width: 14.0),
        if (homeData.isFlashDeal)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FlashDealList();
                }));
              },
              child: Container(
                height: 90,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/flash_deal.png")),
                    ),
                    Text(AppLocalizations.of(context)!.flash_deal_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget buildHomeMenuRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(
                  selected_filter: "brands",
                );
              }));
            },
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width / 3 - 4,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/brands.png")),
                  ),
                  Text(AppLocalizations.of(context)!.brands_ucf,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(132, 132, 132, 1),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
          ),
        ),
        if (vendor_system.$)
          SizedBox(
            width: 10,
          ),
        if (vendor_system.$)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return TopSellers();
                }));
              },
              child: Container(
                height: 90,
                width: MediaQuery.of(context).size.width / 3 - 4,
                decoration: BoxDecorations.buildBoxDecoration_1(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/top_sellers.png")),
                    ),
                    Text(AppLocalizations.of(context)!.top_sellers_ucf,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // Don't show the leading button
      backgroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      flexibleSpace: Padding(
        // padding:
        //     const EdgeInsets.only(top: 40.0, bottom: 22, left: 18, right: 18),
        padding:
            const EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter();
            }));
          },
          child: HomeSearchBox(context: context),
        ),
      ),
    );
  }

  Container buildProductLoadingContainer(HomePresenter homeData) {
    return Container(
      height: homeData.showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
            homeData.totalAllProductData == homeData.allProductList.length
                ? AppLocalizations.of(context)!.no_more_products_ucf
                : AppLocalizations.of(context)!.loading_more_products_ucf),
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
        image: NetworkImage(img.banner!),
        fit: BoxFit.cover,
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
