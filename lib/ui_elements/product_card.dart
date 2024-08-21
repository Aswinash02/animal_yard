import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/helpers/main_helpers.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/product/product_details.dart';
import 'package:flutter/material.dart';

import '../data_model/product_mini_response.dart';
import '../helpers/shared_value_helper.dart';
import '../screens/auction/auction_products_details.dart';

class ProductCard extends StatefulWidget {
  Product product;
  bool isFood;

  ProductCard({Key? key, required this.product, this.isFood = false})
      : super(key: key);

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
      child: productContainer(widget.product, widget.isFood),
    );
  }

  Widget productContainer(Product data, bool isFood) {
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
              height: 120,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: data.thumbnail_image!,
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
                      value: convertPrice(data.main_price!),
                    ),
                    // keyValueWidget(title: 'Age', value: '5 Years'),
                    SizedBox(
                      height: 10,
                    ),
                    widget.isFood
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: buyNowButton())
                        : SizedBox(),
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

  Widget buyNowButton() {
    return GestureDetector(
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: CustomText(
            text: "Buy Now",
            color: Colors.white,
            fontSize: 10,
          ),
          decoration: BoxDecoration(
              color: MyTheme.accent_color,
              borderRadius: BorderRadius.circular(15)),
        ));
  }
}
