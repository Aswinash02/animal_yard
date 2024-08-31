import 'dart:async';

import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/controllers/chat_controller.dart';
import 'package:active_ecommerce_flutter/custom/buttons.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/my_widget.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BuyerChatList extends StatefulWidget {
  @override
  _BuyerChatListState createState() => _BuyerChatListState();
}

class _BuyerChatListState extends State<BuyerChatList> {
  ScrollController _xcrollController = ScrollController();
  StreamSubscription<void>? _chatStreamSubscription;
  final controller = Get.find<ChatController>();

  int _page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _chatStreamSubscription = controller.fetchBuyerChatList().listen((_) {});

    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        controller.showLoadingContainer.value = true;
        controller.fetchBuyerChatList();
      }
    });
  }

  reset() {
    controller.buyerChatList.clear();
    controller.isInitial.value = true;
    controller.totalData!.value = 0;
    _page = 1;
    controller.showLoadingContainer.value = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    controller.fetchBuyerChatList();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _chatStreamSubscription?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _chatStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            displacement: 0,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Obx(
                    () => Container(
                      width: DeviceInfo(context).width,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: controller.isInitial.value &&
                              controller.buyerChatList.length == 0
                          ? chatListShimmer()
                          : buildChatListView(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter, child: buildLoadingContainer())
        ],
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: controller.showLoadingContainer.value ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
            controller.totalData!.value == controller.buyerChatList.length
                ? AppLocalizations.of(context)!.no_more_items_ucf
                : AppLocalizations.of(context)!.loading_more_items_ucf),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: UsefulElements.backButton(context),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.messages_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildChatListView() {
    print("yes enterd buyer buildChatListView**********");
    return Obx(
      () => controller.buyerChatList.isEmpty
          ? Center(
              child: Text("No Chat History Found"),
            )
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.buyerChatList.length,
              itemBuilder: (context, index) {
                return Container(
                    width: 100,
                    child: buildChatItem(
                        index,
                        controller.buyerChatList[index].id,
                        controller.buyerChatList[index].shop_name!,
                        controller.buyerChatList[index].shop_logo,
                        controller.buyerChatList[index].title,
                        true,
                        controller.buyerChatList[index].unReadCustomer!));
              }),
    );
  }

  Widget buildChatItem(index, conversationId, String userName, img, sms,
      bool isActive, int unReadCustomer) {
    print("yes enterd buyer **********");
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 20),
      child: Buttons(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        conversation_id: controller.buyerChatList[index].id,
                        messenger_name:
                            controller.buyerChatList[index].shop_name,
                        messenger_title: controller.buyerChatList[index].title,
                        messenger_image:
                            controller.buyerChatList[index].shop_logo,
                      )));
        },
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              margin: EdgeInsets.only(right: 14),
              child: Stack(
                children: [
                  MyWidget.roundImageWithPlaceholder(
                      elevation: 4,
                      borderWidth: 1,
                      url: img,
                      width: 35.0,
                      height: 35.0,
                      fit: BoxFit.cover,
                      borderRadius: 16),
                  Visibility(
                    visible: false,
                    child: Positioned(
                        right: 1,
                        top: 2,
                        child: MyWidget().myContainer(
                            height: 7,
                            width: 7,
                            borderRadius: 7,
                            borderColor: Colors.white,
                            bgColor: isActive ? Colors.green : MyTheme.grey_153,
                            borderWith: 1)),
                  )
                ],
              ),
            ),
            Container(
              width: DeviceInfo(context).width! - 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: DeviceInfo(context).width!,
                    child: Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MyTheme.accent_color),
                    ),
                  ),
                  Container(
                    child: Text(
                      sms,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: MyTheme.grey_153,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            unReadCustomer != 0
                ? Container(
                    height: 24,
                    width: 24,
                    child: Center(
                        child: CustomText(
                      text: unReadCustomer.toString(),
                      fontSize: 12,
                      color: MyTheme.white,
                    )),
                    decoration: BoxDecoration(
                        color: MyTheme.accent_color, shape: BoxShape.circle),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget chatListShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: List.generate(
          20,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: MyTheme.shimmer_base,
                  highlightColor: MyTheme.shimmer_highlighted,
                  child: Container(
                    height: 35,
                    width: 35,
                    margin: EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: MyTheme.brick_red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                ShimmerHelper().buildBasicShimmer(
                    height: 35, width: DeviceInfo(context).width! - 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
