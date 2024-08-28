import 'dart:async';

import 'package:active_ecommerce_flutter/common/custom_text.dart';
import 'package:active_ecommerce_flutter/custom/buttons.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/my_widget.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:active_ecommerce_flutter/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class BuyerChatList extends StatefulWidget {
  @override
  _BuyerChatListState createState() => _BuyerChatListState();
}

class _BuyerChatListState extends State<BuyerChatList> {
  ScrollController _xcrollController = ScrollController();
  StreamSubscription<void>? _chatStreamSubscription;

  List<dynamic> _list = [];
  bool _isInitial = true;
  int _page = 1;
  int? _totalData = 0;
  bool _showLoadingContainer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _chatStreamSubscription = fetchData().listen((_) {});

    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  Stream<void> fetchData() async* {
    while (true) {
      var conversationResponse =
          await ChatRepository().getConversationResponse();

      var newItems = conversationResponse.conversation_item_list.where((item) {
        return !_list.any((existingItem) => existingItem.id == item.id);
      }).toList();
      _list.insertAll(0, newItems);

      _isInitial = false;
      _totalData = conversationResponse.meta.total;
      _showLoadingContainer = false;

      if (mounted) setState(() {});
      yield null;

      await Future.delayed(Duration(seconds: 5)); // Adjust the delay as needed
    }
  }

  reset() {
    _list.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print('deactived -- mgs---------');
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
                  child: Container(
                    width: DeviceInfo(context).width,
                    //height: DeviceInfo(context).getHeight(),
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: buildChatListView(),
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
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _list.length
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
    return _isInitial && _list.length == 0
        ? chatListShimmer()
        : _list.isEmpty
            ? Center(
                child: Text("No Chat History Found"),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: 100,
                      child: buildChatItem(
                          index,
                          _list[index].id,
                          _list[index].shop_name,
                          _list[index].shop_logo,
                          _list[index].title,
                          true,
                          _list[index].unReadSeller));
                });
  }

  Widget buildChatItem(index, conversationId, String userName, img, sms,
      bool isActive, int count) {
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 20),
      child: Buttons(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        conversation_id: _list[index].id,
                        messenger_name: _list[index].shop_name,
                        messenger_title: _list[index].title,
                        messenger_image: _list[index].shop_logo,
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
            count != 0
                ? Container(
                    height: 24,
                    width: 24,
                    child: Center(
                        child: CustomText(
                      text: count.toString(),
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
