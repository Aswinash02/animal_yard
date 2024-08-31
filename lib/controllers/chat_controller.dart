import 'package:active_ecommerce_flutter/data_model/conversation_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_chat_list.dart';
import 'package:active_ecommerce_flutter/repositories/chat_repository.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxInt _count = 0.obs;
  RxList<Chat> sellerChatList = <Chat>[].obs;
  RxBool sellerFaceData = false.obs;
  RxBool sellerLoadingState = false.obs;

  RxList<ConversationItem> buyerChatList = <ConversationItem>[].obs;
  RxBool isInitial = true.obs;
  RxInt? totalData = 0.obs;
  RxBool showLoadingContainer = false.obs;

  RxInt get count => _count;

  void isBatch(int value) {
    _count.value = value;
  }


  Stream<void> fetchSellerChatList() async* {
    sellerLoadingState.value = true;
    while (true) {
      var response = await ChatRepository().getChatList();
      if (response.data != null) {
        response.data!.forEach((newItem) {
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
    showLoadingContainer.value = true;

    while (true) {
      var response = await ChatRepository().getConversationResponse();

      response.conversation_item_list.forEach((newItem) {
        var existingIndex = buyerChatList
            .indexWhere((existingItem) => existingItem.id == newItem.id);

        if (existingIndex != -1) {
          if (buyerChatList[existingIndex].unReadSeller !=
              newItem.unReadSeller) {
            if (buyerChatList[existingIndex].unReadSeller! >
                newItem.unReadSeller!) {
              buyerChatList.removeAt(existingIndex);
              buyerChatList.insert(0, newItem);
            } else {
              buyerChatList[existingIndex] = newItem;
            }
            // buyerChatList.removeAt(existingIndex);
            // buyerChatList.insert(0, newItem);
            // buyerChatList[existingIndex] = newItem;
          }
        } else {
          buyerChatList.insert(0, newItem);
        }
      });

      isInitial.value = false;
      totalData!.value = response.meta.total;
      showLoadingContainer.value = false;

      yield null;

      await Future.delayed(Duration(seconds: 3));
    }
  }
}
