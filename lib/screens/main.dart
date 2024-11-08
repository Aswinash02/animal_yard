import 'dart:async';

import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/controllers/chat_controller.dart';
import 'package:active_ecommerce_flutter/data_model/conversation_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_chat_list.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/add_product/seller_add_product.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/chat_list/widget/chat_tab_bar.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/seller_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Main extends StatefulWidget {
  Main({Key? key, this.goBack = true}) : super(key: key);
  final bool goBack;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return SellerDashBoard();
  }
}

class SellerDashBoard extends StatefulWidget {
  const SellerDashBoard({Key? key}) : super(key: key);

  @override
  State<SellerDashBoard> createState() => _SellerDashBoardState();
}

class _SellerDashBoardState extends State<SellerDashBoard> {
  StreamSubscription<void>? _chatStreamSubscription;

  @override
  void initState() {
    Permission.location.request();
    _chatStreamSubscription = listenChatStream().listen((_) {});
    super.initState();
  }

  Stream<void> listenChatStream() async* {
    while (true) {
      ConversationResponse buyerMessageCount =
          await ChatRepository().getConversationResponse();
      ChatListResponse sellerMessageCount =
          await ChatRepository().getChatList();
      if (buyerMessageCount.unReadCustomer! > 0) {
        Get.find<ChatController>().isBatch(buyerMessageCount.unReadCustomer!);
      } else if (sellerMessageCount.unReadSeller! > 0) {
        Get.find<ChatController>().isBatch(sellerMessageCount.unReadSeller!);
      } else {
        Get.find<ChatController>().isBatch(0);
      }

      yield null;
      await Future.delayed(Duration(seconds: 5)); // Adjust the delay as needed
    }
  }

  @override
  void dispose() {
    _chatStreamSubscription?.cancel();
    super.dispose();
  }

  int _selectedIndex = 0;

  List<Widget> _buildSellerPageList = [
    Home(),
    ProductSeller(
      fromBottomBar: false,
    ),
    ChatTabBar(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _buildSellerPageList[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyTheme.accent_color,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewProduct()),
            );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Container(
            height: 70,
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => _onItemTapped(0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomIcon(
                                  icon: "assets/home.png",
                                  color: _selectedIndex == 0
                                      ? MyTheme.accent_color
                                      : Colors.grey,
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  text: "Home",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  color: _selectedIndex == 0
                                      ? MyTheme.accent_color
                                      : Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onItemTapped(1),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomIcon(
                                  icon: "assets/products.png",
                                  color: _selectedIndex == 1
                                      ? MyTheme.accent_color
                                      : Colors.grey,
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  text: "Product",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  color: _selectedIndex == 1
                                      ? MyTheme.accent_color
                                      : Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomText(
                        text: "Sell",
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey,
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => _onItemTapped(2),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomIcon(
                                      icon: "assets/messages.png",
                                      color: _selectedIndex == 2
                                          ? MyTheme.accent_color
                                          : Colors.grey,
                                    ),
                                    SizedBox(height: 4),
                                    CustomText(
                                      text: "Chat",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200,
                                      color: _selectedIndex == 2
                                          ? MyTheme.accent_color
                                          : Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () => Get.find<ChatController>()
                                      .isBadgeDisplay
                                      .value
                                  ? Positioned(
                                      right: 0,
                                      top: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: MyTheme.accent_color,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _onItemTapped(3),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomIcon(
                                  icon: "assets/profile.png",
                                  color: _selectedIndex == 3
                                      ? MyTheme.accent_color
                                      : Colors.grey,
                                ),
                                SizedBox(height: 4),
                                CustomText(
                                  text: "Profile",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  color: _selectedIndex == 3
                                      ? MyTheme.accent_color
                                      : Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final double? height;
  final double? width;
  final String icon;
  final Color? color;

  const CustomIcon(
      {super.key, this.height, this.width, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 18,
      width: width ?? 16,
      child: Image(
        image: AssetImage(icon),
        color: color ?? Colors.black,
      ),
    );
  }
}
