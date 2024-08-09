import 'package:active_ecommerce_flutter/common/appicons.dart';
import 'package:active_ecommerce_flutter/common/custom_icon.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../my_theme.dart';
import 'box_decorations.dart';

class HomeSearchBox extends StatelessWidget {
  final BuildContext? context;

  const HomeSearchBox({Key? key, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Filter();
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecorations.buildBoxDecoration_1(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.search_anything,
                      style: TextStyle(
                          fontSize: 13.0, color: MyTheme.textfield_grey),
                    ),
                    Image.asset(
                      'assets/search.png',
                      height: 16,
                      //color: MyTheme.dark_grey,
                      color: MyTheme.dark_grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter();
              }));
            },
            icon: Icon(Icons.filter_alt_sharp, color: MyTheme.accent_color),
          )
        ],
      ),
    );
  }
}
