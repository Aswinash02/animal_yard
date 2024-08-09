import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';

class MDecoration{
  static BoxDecoration decoration1({double radius =6.0 ,bool showShadow=true}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: MyTheme.white,
      boxShadow: [
        showShadow?BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: const Offset(0.0, 10.0), // shadow direction: bottom right
        ):const BoxShadow()
      ],
    );
  }



}