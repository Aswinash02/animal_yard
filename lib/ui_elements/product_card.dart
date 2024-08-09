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

  // var identifier;
  // int? id;
  // String slug;
  // String? image;
  // String? name;
  // String? main_price;
  // String? stroked_price;
  // bool? has_discount;
  // bool? is_wholesale;
  // var discount;

  ProductCard({Key? key, required this.product
      // this.identifier,
      // required this.slug,
      // this.id,
      // this.image,
      // this.name,
      // this.main_price,
      // this.is_wholesale = false,
      // this.stroked_price,
      // this.has_discount,
      // this.discount,
      })
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
      child: productContainer(widget.product),
    );
    // return InkWell(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) {
    //           return ProductDetails(
    //                   slug: widget.product.slug!,
    //                 );
    //         },
    //       ),
    //     );
    //   },
    //   child: Container(
    //     decoration: BoxDecorations.buildBoxDecoration_1().copyWith(),
    //     child: Stack(
    //       children: [
    //         Column(children: <Widget>[
    //           AspectRatio(
    //             aspectRatio: 1,
    //             child: Container(
    //               width: double.infinity,
    //               child: ClipRRect(
    //                 clipBehavior: Clip.hardEdge,
    //                 borderRadius: BorderRadius.vertical(
    //                     top: Radius.circular(6), bottom: Radius.zero),
    //                 child: FadeInImage.assetNetwork(
    //                   placeholder: 'assets/placeholder.png',
    //                   image: widget.image!,
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Container(
    //             width: double.infinity,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
    //                   child: Text(
    //                     widget.name!,
    //                     overflow: TextOverflow.ellipsis,
    //                     maxLines: 2,
    //                     style: TextStyle(
    //                         color: MyTheme.font_grey,
    //                         fontSize: 14,
    //                         height: 1.2,
    //                         fontWeight: FontWeight.w400),
    //                   ),
    //                 ),
    //                 widget.has_discount!
    //                     ? Padding(
    //                         padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
    //                         child: Text(
    //                           SystemConfig.systemCurrency != null
    //                               ? widget.stroked_price!.replaceAll(
    //                                   SystemConfig.systemCurrency!.code!,
    //                                   SystemConfig.systemCurrency!.symbol!)
    //                               : widget.stroked_price!,
    //                           textAlign: TextAlign.left,
    //                           overflow: TextOverflow.ellipsis,
    //                           maxLines: 1,
    //                           style: TextStyle(
    //                               decoration: TextDecoration.lineThrough,
    //                               color: MyTheme.medium_grey,
    //                               fontSize: 12,
    //                               fontWeight: FontWeight.w400),
    //                         ),
    //                       )
    //                     : Container(
    //                         height: 8.0,
    //                       ),
    //                 Padding(
    //                   padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
    //                   child: Text(
    //                     SystemConfig.systemCurrency! != null
    //                         ? widget.main_price!.replaceAll(
    //                             SystemConfig.systemCurrency!.code!,
    //                             SystemConfig.systemCurrency!.symbol!)
    //                         : widget.main_price!,
    //                     textAlign: TextAlign.left,
    //                     overflow: TextOverflow.ellipsis,
    //                     maxLines: 1,
    //                     style: TextStyle(
    //                         color: MyTheme.accent_color,
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.w700),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ]),
    //
    //         // discount and wholesale
    //         Positioned.fill(
    //           child: Align(
    //             alignment: Alignment.topRight,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 if (widget.has_discount!)
    //                   Container(
    //                     padding:
    //                         EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    //                     margin: EdgeInsets.only(bottom: 5),
    //                     decoration: BoxDecoration(
    //                       color: const Color(0xffe62e04),
    //                       borderRadius: BorderRadius.only(
    //                         topRight: Radius.circular(6.0),
    //                         bottomLeft: Radius.circular(6.0),
    //                       ),
    //                       boxShadow: [
    //                         BoxShadow(
    //                           color: const Color(0x14000000),
    //                           offset: Offset(-1, 1),
    //                           blurRadius: 1,
    //                         ),
    //                       ],
    //                     ),
    //                     child: Text(
    //                       widget.discount ?? "",
    //                       style: TextStyle(
    //                         fontSize: 10,
    //                         color: const Color(0xffffffff),
    //                         fontWeight: FontWeight.w700,
    //                         height: 1.8,
    //                       ),
    //                       textHeightBehavior: TextHeightBehavior(
    //                           applyHeightToFirstAscent: false),
    //                       softWrap: false,
    //                     ),
    //                   ),
    //                 Visibility(
    //                   visible: whole_sale_addon_installed.$,
    //                   child: widget.is_wholesale != null && widget.is_wholesale!
    //                       ? Container(
    //                           padding: EdgeInsets.symmetric(
    //                               horizontal: 12, vertical: 4),
    //                           decoration: BoxDecoration(
    //                             color: Colors.blueGrey,
    //                             borderRadius: BorderRadius.only(
    //                               topRight: Radius.circular(6.0),
    //                               bottomLeft: Radius.circular(6.0),
    //                             ),
    //                             boxShadow: [
    //                               BoxShadow(
    //                                 color: const Color(0x14000000),
    //                                 offset: Offset(-1, 1),
    //                                 blurRadius: 1,
    //                               ),
    //                             ],
    //                           ),
    //                           child: Text(
    //                             "Wholesale",
    //                             style: TextStyle(
    //                               fontSize: 10,
    //                               color: const Color(0xffffffff),
    //                               fontWeight: FontWeight.w700,
    //                               height: 1.8,
    //                             ),
    //                             textHeightBehavior: TextHeightBehavior(
    //                                 applyHeightToFirstAscent: false),
    //                             softWrap: false,
    //                           ),
    //                         )
    //                       : SizedBox.shrink(),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget productContainer(Product data) {
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
              height: 100,
              width: double.infinity,
              child: ClipRRect(
                // clipBehavior: Clip.hardEdge,
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

                    keyValueWidget(title: 'Age', value: '5 Years'),

                    SizedBox(
                      height: 14,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: buyNowButton()),
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
          // Container(
          //   width: 40,
          //   child: Text(
          //     title,
          //     style: TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.w700,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
          //   child: Text(
          //     ":",
          //     style: TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.w700,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
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
      // child: RichText(
      //   text: TextSpan(
      //     text: '$title : ', // Part of the text
      //     style: TextStyle(
      //       fontSize: 12,
      //       fontWeight: FontWeight.w700,
      //       color: Colors.black,
      //     ),
      //     children: [
      //       TextSpan(
      //         text: value, // The dynamic part
      //         style: TextStyle(
      //           fontSize: 10,
      //           fontWeight: FontWeight.w700,
      //           color:
      //               Colors.black, // Specify color or other properties if needed
      //         ),
      //       ),
      //     ],
      //   ),
      //   maxLines: 4,
      // ),
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
              fontSize: 12,
              fontWeight: FontWeight.w700,
              maxLines: 4,
            )),
        SizedBox(
          width: 3,
        ),
        keyValueWidget(title: title, value: value),
      ],
    );
  }

  Widget buyNowButton() {
    return GestureDetector(
        onTap: () {},
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
