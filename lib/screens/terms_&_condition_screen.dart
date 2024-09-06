import 'package:active_ecommerce_flutter/common/custom_app_bar.dart';
import 'package:active_ecommerce_flutter/controllers/profile_controller.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Terms & Conditions",
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: MyTheme.blackColor,
          ),
        ),
      ),
      body: GetBuilder<ProfileController>(builder: (controller) {
        return controller.pageDataList.isEmpty ||
                controller.pageDataList[4].content == null
            ? const Center(
                child: Text("Terms & Conditions"),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Html(
                    data: controller.pageDataList[4].content!,
                    style: {
                      "body": Style(
                        fontSize: FontSize.large,
                        color: Colors.black87,
                      ),
                    },
                  ),
                ),
              );
      }),
    );
  }
}
