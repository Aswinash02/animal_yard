import 'package:active_ecommerce_flutter/data_model/conversation_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_chat_list.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  RxBool _isBadgeDisplay = false.obs;
  RxList<Chat> sellerChatList = <Chat>[].obs;
  RxBool sellerFaceData = false.obs;
  RxBool buyerFaceData = false.obs;
  RxBool sellerLoadingState = false.obs;
  RxBool buyerLoadingState = false.obs;

  RxList<ConversationItem> buyerChatList = <ConversationItem>[].obs;
  RxBool isInitial = true.obs;
  RxInt? totalData = 0.obs;
  RxBool showLoadingContainer = false.obs;

  RxBool get isBadgeDisplay => _isBadgeDisplay;

  void isBatch(int value) {
    if (value > 0) {
      _isBadgeDisplay.value = true;
    } else {
      _isBadgeDisplay.value = false;
    }
  }

  Stream<void> fetchSellerChatList() async* {
    sellerLoadingState.value = true;
    while (true) {
      var response = await ChatRepository().getChatList();
      if (response.data != null) {
        response.data!.forEach((newItem) {
          final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
          response.data!.sort((a, b) {
            DateTime dateA = dateFormat.parse(a.dateTime!);
            DateTime dateB = dateFormat.parse(b.dateTime!);
            return dateB.compareTo(dateA);
          });
          sellerChatList.value = response.data!;
        });
      }
      sellerFaceData.value = true;
      sellerLoadingState.value = false;
      yield null;
      await Future.delayed(Duration(seconds: 3));
    }
  }

  Stream<void> fetchBuyerChatList() async* {
    buyerLoadingState.value = true;

    while (true) {
      var response = await ChatRepository().getConversationResponse();
      if (response.conversation_item_list != null) {
        response.conversation_item_list!.forEach((newItem) {
          response.conversation_item_list!.sort((a, b) {
            DateTime dateA = a.date!;
            DateTime dateB = b.date!;
            return dateB.compareTo(dateA);
          });
          buyerChatList.value = response.conversation_item_list!;
        });
      }

      buyerFaceData.value = true;
      buyerLoadingState.value = false;
      yield null;
      await Future.delayed(Duration(seconds: 3));
    }
  }
}
