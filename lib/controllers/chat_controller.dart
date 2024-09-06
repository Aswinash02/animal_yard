import 'package:active_ecommerce_flutter/data_model/conversation_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_chat_list.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:get/get.dart';

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
        response.data!.reversed.forEach((newItem) {
          var existingIndex = sellerChatList
              .indexWhere((existingItem) => existingItem.id == newItem.id);
          if (existingIndex != -1) {
            if (sellerChatList[existingIndex].unReadSeller !=
                newItem.unReadSeller) {
              if (sellerChatList[existingIndex].unReadSeller! >
                  newItem.unReadSeller!) {
                sellerChatList.removeAt(existingIndex);
                sellerChatList.insert(0, newItem);
              } else {
                sellerChatList[existingIndex] = newItem;
              }
            }
          } else {
            sellerChatList.insert(0, newItem);
          }
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
        response.conversation_item_list!.reversed.forEach((newItem) {
          var existingIndex = buyerChatList
              .indexWhere((existingItem) => existingItem.id == newItem.id);

          if (existingIndex != -1) {
            if (buyerChatList[existingIndex].unReadCustomer !=
                newItem.unReadCustomer) {
              if (buyerChatList[existingIndex].unReadCustomer! >
                  newItem.unReadCustomer!) {
                buyerChatList.removeAt(existingIndex);
                buyerChatList.insert(0, newItem);
              } else {
                buyerChatList[existingIndex] = newItem;
              }
            }
          } else {
            buyerChatList.insert(0, newItem);
          }
        });
      }

      buyerFaceData.value = true;
      buyerLoadingState.value = false;
      yield null;
      await Future.delayed(Duration(seconds: 3));
    }
  }
}
