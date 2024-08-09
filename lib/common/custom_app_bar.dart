import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, this.leading, required this.title, this.actions});

  final Widget? leading;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: AppBar(
        leading: leading,
        centerTitle: true,
        title: CustomText(
          text: title,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
        actions: actions,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
