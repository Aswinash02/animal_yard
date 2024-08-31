import 'dart:async';

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
      }
      if (sellerMessageCount.unReadSeller! > 0) {
        Get.find<ChatController>().isBatch(sellerMessageCount.unReadSeller!);
      }
      print('badgeCount.unReadSeller ---- > ${buyerMessageCount.unReadSeller}');
      print(
          'badgeCount.unReadCustomer ---- > ${buyerMessageCount.unReadCustomer}');
      print('---- > ${sellerMessageCount.unReadSeller}');
      print('---- > ${sellerMessageCount.unReadCustomer}');

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
                        IconButton(
                          icon: CustomIcon(
                            icon: "assets/home.png",
                            color: _selectedIndex == 0
                                ? MyTheme.accent_color
                                : Colors.grey,
                          ),
                          onPressed: () => _onItemTapped(0),
                        ),
                        IconButton(
                          icon: CustomIcon(
                            icon: "assets/products.png",
                            color: _selectedIndex == 1
                                ? MyTheme.accent_color
                                : Colors.grey,
                          ),
                          onPressed: () => _onItemTapped(1),
                          color: _selectedIndex == 1
                              ? MyTheme.accent_color
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              icon: CustomIcon(
                                icon: "assets/messages.png",
                                color: _selectedIndex == 2
                                    ? MyTheme.accent_color
                                    : Colors.grey,
                              ),
                              onPressed: () => _onItemTapped(2),
                            ),
                            Obx(
                              () => Get.find<ChatController>().count > 0
                                  ? Positioned(
                                      right: 6,
                                      top: 6,
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
                        IconButton(
                          icon: CustomIcon(
                            icon: "assets/profile.png",
                            color: _selectedIndex == 3
                                ? MyTheme.accent_color
                                : Colors.grey,
                          ),
                          onPressed: () => _onItemTapped(3),
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
