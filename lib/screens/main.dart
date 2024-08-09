import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/providers/locale_provider.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list_n_product/category_list.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/add_product/seller_add_product.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/chat_list/chat_list_page.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/chat_list/conversation_seller.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/seller_products.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Main extends StatefulWidget {
  Main({Key? key, this.goBack = true}) : super(key: key);
  final bool goBack;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return user_type.$ == 'customer' ? CustomerDashBoard() : SellerDashBoard();
  }
}

class SellerDashBoard extends StatefulWidget {
  const SellerDashBoard({Key? key}) : super(key: key);

  @override
  State<SellerDashBoard> createState() => _SellerDashBoardState();
}

class _SellerDashBoardState extends State<SellerDashBoard> {
  int _selectedIndex = 0;

  List<Widget> _buildSellerPageList() {
    return [
      Home(),
      ProductSeller(
        fromBottomBar: false,
      ),
      ChatList(),
      Profile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('_selectedIndex $_selectedIndex');
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
          print('_selectedIndex-- if -- $_selectedIndex');
          return false;
        }
        print('_selectedIndex---- $_selectedIndex');
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _buildSellerPageList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyTheme.accent_color,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewProduct()
                  //     CommonWebviewScreen(
                  //   url:
                  //       "https://animalyard.in/info/seller/login/products/${user_phone.$}",
                  //   page_name: "Add Product",
                  // ),
                  ),
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
                        IconButton(
                          icon: CustomIcon(
                            icon: "assets/messages.png",
                            color: _selectedIndex == 2
                                ? MyTheme.accent_color
                                : Colors.grey,
                          ),
                          onPressed: () => _onItemTapped(2),
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

class CustomerDashBoard extends StatefulWidget {
  const CustomerDashBoard({Key? key}) : super(key: key);

  @override
  State<CustomerDashBoard> createState() => _CustomerDashBoardState();
}

class _CustomerDashBoardState extends State<CustomerDashBoard> {
  int _selectedIndex = 0;

  List<Widget> customerList = [
    Home(),
    CategoryList(
      slug: "",
      is_base_category: true,
      digital: 1,
    ),
    Cart(
      has_bottomnav: true,
      from_navigation: true,
      counter: CartCounter(),
    ),
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
        body: customerList[_selectedIndex],
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
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
                    icon: "assets/categories.png",
                    color: _selectedIndex == 1
                        ? MyTheme.accent_color
                        : Colors.grey,
                  ),
                  onPressed: () => _onItemTapped(1),
                ),
                IconButton(
                  icon: badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: MyTheme.accent_color,
                      borderRadius: BorderRadius.circular(10),
                      padding: EdgeInsets.all(4),
                    ),
                    badgeAnimation: badges.BadgeAnimation.slide(
                      toAnimate: false,
                    ),
                    child: CustomIcon(
                      icon: "assets/cart.png",
                      color: _selectedIndex == 2
                          ? MyTheme.accent_color
                          : Colors.grey,
                    ),
                    badgeContent: Consumer<CartCounter>(
                      builder: (context, cart, child) {
                        return Text(
                          "${cart.cartCounter}",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  onPressed: () => _onItemTapped(2),
                  color: _selectedIndex == 2 ? Colors.amber[800] : Colors.grey,
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
