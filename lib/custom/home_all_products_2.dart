import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/helpers/main_helpers.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/home_presenter.dart';
import 'package:active_ecommerce_flutter/screens/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../helpers/shimmer_helper.dart';
import '../ui_elements/product_card.dart';

class HomeAllProducts2 extends StatelessWidget {
  final BuildContext? context;
  final HomePresenter? homeData;

  const HomeAllProducts2({
    Key? key,
    this.context,
    this.homeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (homeData!.isAllProductInitial) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: homeData!.allProductScrollController));
    } else if (homeData!.allProductList.length > 0) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeData!.allProductList.length,
          itemBuilder: (context, index) {
            final data = homeData!.allProductList[index];
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ProductCard(
                  product: data,
                )
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductDetails(
                        slug: data.slug,
                      );
                    },
                  ),
                );
              },
            );
          });
      // MasonryGridView.count(
      //   crossAxisCount: 2,
      //   mainAxisSpacing: 14,
      //   crossAxisSpacing: 14,
      //   itemCount: homeData!.allProductList.length,
      //   shrinkWrap: true,
      //   padding: EdgeInsets.only(top: 20.0, bottom: 10, left: 18, right: 18),
      //   physics: NeverScrollableScrollPhysics(),
      //   itemBuilder: (context, index) {
      //     return ProductCard(
      //       id: homeData!.allProductList[index].id,
      //       slug: homeData!.allProductList[index].slug,
      //       image: homeData!.allProductList[index].thumbnail_image,
      //       name: homeData!.allProductList[index].name,
      //       main_price: homeData!.allProductList[index].main_price,
      //       stroked_price: homeData!.allProductList[index].stroked_price,
      //       has_discount: homeData!.allProductList[index].has_discount,
      //       discount: homeData!.allProductList[index].discount,
      //       is_wholesale: homeData!.allProductList[index].isWholesale,
      //     );
      //   });
    } else if (homeData!.totalAllProductData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
}
