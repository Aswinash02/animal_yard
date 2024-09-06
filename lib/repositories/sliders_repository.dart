import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/food_banner_model.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/slider_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class SlidersRepository {
  Future<SliderResponse> getSliders() async {
    String url = ("${AppConfig.BASE_URL}/sliders");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );
    return sliderResponseFromJson(response.body);
  }

  Future<SliderResponse> getBannerOneImages() async {
    String url = ("${AppConfig.BASE_URL}/banners-one");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );
    return sliderResponseFromJson(response.body);
  }

  Future<FoodBannerModel> getFoodBannerImage() async {
    String url = ("${AppConfig.BASE_URL}/banner");
    print('url************* $url');
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );
    print('response.body ***** ${response.body}');
    return FoodBannerModel.fromJson(jsonDecode(response.body));
  }

  Future<SliderResponse> getBannerTwoImages() async {
    String url = ("${AppConfig.BASE_URL}/banners-two");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );
    return sliderResponseFromJson(response.body);
  }

  Future<SliderResponse> getBannerThreeImages() async {
    String url = ("${AppConfig.BASE_URL}/banners-three");
    final response = await ApiRequest.get(
      url: url,
      headers: {
        "App-Language": app_language.$!,
      },
    );
    return sliderResponseFromJson(response.body);
  }
}
