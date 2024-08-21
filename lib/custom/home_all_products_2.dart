import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/data_model/animal_product_response.dart';
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
    } else if (homeData!.animalProductList.length > 0) {
      return
          MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              itemCount: homeData!.animalProductList.length,
              shrinkWrap: true,
              padding:
                  EdgeInsets.only(top: 20.0, bottom: 10, left: 18, right: 18),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final data = homeData!.animalProductList[index];
                return InkWell(
                  child: ProductCard(
                    product: data,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ProductDetails(
                            slug: data.slug ?? '',
                          );
                        },
                      ),
                    );
                  },
                );
              });
    } else if (homeData!.totalAllProductData == 0) {
      return Center(
          child: Text(AppLocalizations.of(context)!.no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }
}


class ProductCard extends StatefulWidget {
  AnimalData product;

  ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetails(
                slug: widget.product.slug!,
              );
            },
          ),
        );
      },
      child: productContainer(widget.product),
    );
  }

  Widget productContainer(AnimalData data) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 145,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 130,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: data.thumbnailImage ?? '',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    infoRow(
                      text: data.name!,
                      title: 'Price',
                      value: convertPrice(data.mainPrice ?? ''),
                    ),
                  ],
                ))
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget keyValueWidget({required String title, required String value}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color:
              Colors.black, // Specify color or other properties if needed
            ),
          )
        ],
      ),
    );
  }

  Widget infoRow(
      {required String text, required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            color: Colors.white,
            child: CustomText(
              text: text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              maxLines: 2,
            )),
        SizedBox(
          height: 4,
        ),
        keyValueWidget(title: title, value: value),
      ],
    );
  }
}
