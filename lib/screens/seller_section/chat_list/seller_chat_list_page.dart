import 'dart:async';

import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/controllers/chat_controller.dart';
import 'package:active_ecommerce_flutter/custom/buttons.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/my_widget.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SellerChatList extends StatefulWidget {
  const SellerChatList({Key? key}) : super(key: key);

  @override
  State<SellerChatList> createState() => _SellerChatListState();
}

class _SellerChatListState extends State<SellerChatList> {
  StreamSubscription<void>? _chatStreamSubscription;
  final controller = Get.find<ChatController>();

  faceData() {
    controller.fetchSellerChatList();
  }

  clearData() {
    controller.sellerChatList.clear();
    controller.sellerFaceData.value = false;
  }

  Future<bool> resetData() async {
    clearData();
    faceData();
    return true;
  }

  Future<void> refresh() async {
    await resetData();
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    _chatStreamSubscription = controller.fetchSellerChatList().listen((_) {});
    // TODO: implement initState
    super.initState();
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
    return RefreshIndicator(
      onRefresh: refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Obx(() {
              print('yes rebuild');
              return Container(
                width: DeviceInfo(context).width,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: controller.sellerFaceData.value
                    ? buildChatListView()
                    : chatListShimmer(),
              );
            }),
          ),
        ],
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
                )),
      ),
    );
  }

  Widget buildChatListView() {
    return Obx(
      () {
        print('rebuild chatListShimmer');
        return controller.sellerLoadingState.value
            ? chatListShimmer()
            : controller.sellerChatList.isEmpty
                ? Center(
                    child: Text("No Chat History Found"),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.sellerChatList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        child: buildChatItem(
                          index,
                          controller.sellerChatList[index].id,
                          controller.sellerChatList[index].name!,
                          controller.sellerChatList[index].image,
                          controller.sellerChatList[index].title,
                          true,
                          controller.sellerChatList[index].unReadCustomer ?? 0,
                          controller.sellerChatList[index].unReadSeller ?? 0,
                        ),
                      );
                    },
                  );
      },
    );
  }

  Widget buildChatItem(index, conversationId, String userName, img, sms,
      bool isActive, int unReadCustomer, int unReadSeller) {
    print('yes enter isActive ------- $unReadSeller');
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 20),
      child: Buttons(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversation_id: controller.sellerChatList[index].id,
                messenger_name: controller.sellerChatList[index].name!,
                messenger_title: controller.sellerChatList[index].title,
                messenger_image: controller.sellerChatList[index].image,
              ),
            ),
          );
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
            if (unReadSeller > 0)
              Container(
                height: 24,
                width: 24,
                child: Center(
                    child: CustomText(
                  text: unReadSeller.toString(),
                  fontSize: 12,
                  color: MyTheme.white,
                )),
                decoration: BoxDecoration(
                    color: MyTheme.accent_color, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
