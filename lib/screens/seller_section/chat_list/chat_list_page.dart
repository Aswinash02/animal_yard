import 'dart:async';

import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/custom/buttons.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/my_widget.dart';
import 'package:active_ecommerce_flutter/data_model/seller_chat_list.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:active_ecommerce_flutter/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SellerChatList extends StatefulWidget {
  const SellerChatList({Key? key}) : super(key: key);

  @override
  State<SellerChatList> createState() => _SellerChatListState();
}

class _SellerChatListState extends State<SellerChatList> {
  List<Chat> _chatList = [];
  bool _faceData = false;
  bool _loadingState = false;
  StreamSubscription<void>? _chatStreamSubscription;

  faceData() {
    getCouponList();
  }

  clearData() {
    _chatList = [];
    _faceData = false;
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
    _chatStreamSubscription = getCouponList().listen((_) {});
    // TODO: implement initState
    super.initState();
  }

  Stream<void> getCouponList() async* {
    _loadingState = true;
    setState(() {});
    while (true) {
      var response = await ChatRepository().getChatList();
      if (response.data != null) {
        var newItems = response.data!.where((item) {
          return !_chatList.any((existingItem) => existingItem.id == item.id);
        }).toList();
        _chatList.insertAll(0, newItems);
      }
      _faceData = true;
      _loadingState = false;
      if (mounted) setState(() {});
      yield null;
      await Future.delayed(Duration(seconds: 5));
    }
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
            child: Container(
              width: DeviceInfo(context).width,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: _faceData ? buildChatListView() : chatListShimmer(),
            ),
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
    return _loadingState
        ? chatListShimmer()
        : _chatList.isEmpty
            ? Center(
                child: Text("No Chat History Found"),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _chatList.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: 100,
                      child: buildChatItem(
                        index,
                        _chatList[index].id,
                        _chatList[index].name!,
                        _chatList[index].image,
                        _chatList[index].title,
                        true,
                        _chatList[index].unReadCustomer ?? 0,
                        _chatList[index].unReadSeller ?? 0,
                      ));
                });
  }

  Widget buildChatItem(index, conversationId, String userName, img, sms,
      bool isActive, int unReadCustomer, int unReadSeller) {
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 20),
      child: Buttons(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        conversation_id: _chatList[index].id,
                        messenger_name: _chatList[index].name!,
                        messenger_title: _chatList[index].title,
                        messenger_image: _chatList[index].image,
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
            if (unReadCustomer > 0)
              Container(
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
              ),
          ],
        ),
      ),
    );
  }
}
