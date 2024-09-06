import 'package:active_ecommerce_flutter/common/custom_app_bar.dart';
import 'package:active_ecommerce_flutter/custom/buttons.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/chat/buyer_chat_list.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/chat_list/seller_chat_list_page.dart';
import 'package:flutter/material.dart';

class ChatTabBar extends StatefulWidget {
  const ChatTabBar({super.key});

  @override
  State<ChatTabBar> createState() => _ChatTabBarState();
}

class _ChatTabBarState extends State<ChatTabBar> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LangText(context).local.chat_list,
      ),
      body: Column(
        children: [
          Row(
            children: [
              buildTopTapBarItem(LangText(context).local.buying_ucf, 0),
              buildTopTapBarItem(LangText(context).local.selling_ucf, 1)
            ],
          ),
          Expanded(
            child: changeMainContent(_selectedTabIndex),
          ),
        ],
      ),
    );
  }

  Widget buildBodyContainer() {
    return changeMainContent(_selectedTabIndex);
  }

  Widget changeMainContent(int index) {
    switch (index) {
      case 0:
        return BuyerChatList();
      case 1:
        return SellerChatList();
      default:
        return Container();
    }
  }

  Widget buildTopTapBarItem(String text, int index) {
    return Expanded(
      child: Container(
          height: 50,
          color: _selectedTabIndex == index
              ? MyTheme.accent_color
              : MyTheme.accent_color.withOpacity(0.5),
          child: Buttons(

              onPressed: () {
                _selectedTabIndex = index;
                setState(() {});
              },
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.white),
              ))),
    );
  }
}
