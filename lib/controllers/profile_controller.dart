import 'package:active_ecommerce_flutter/data_model/profile_page_response.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final List<PageData> _pageDataList = [];

  List<PageData> get pageDataList => _pageDataList;

  Future<void> getPageData() async {
    var response = await ProfileRepository().getProfilePageResponse();
    _pageDataList.addAll(response.data!);
    update();
  }
}
