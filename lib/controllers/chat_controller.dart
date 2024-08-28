import 'package:get/get.dart';

class ChatController extends GetxController {
  RxInt _count = 0.obs;

  RxInt get count => _count;

  void isBatch(int value) {
    _count.value = value;
  }
}
