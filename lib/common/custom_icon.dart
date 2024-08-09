import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final Widget icon;
  final Color? iconColor;

  const CustomIcon({super.key, required this.icon, this.iconColor, required Color color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: icon,
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: MyTheme.iconContainerColor, shape: BoxShape.circle),
    );
  }
}
