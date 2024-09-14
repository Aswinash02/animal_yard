import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/attribute_response.dart';
import 'package:active_ecommerce_flutter/data_model/colors_response_model.dart';
import 'package:active_ecommerce_flutter/data_model/common_response.dart';
import 'package:active_ecommerce_flutter/data_model/delete_product_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_duplicate_response.dart';
import 'package:active_ecommerce_flutter/data_model/remaining_product_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_brand_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_category_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_product_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import '../data_model/brand_response.dart';
import '../data_model/common_response_seller.dart';
import '../data_model/product_edit_seller_response.dart';
import 'api-request.dart';

class SellerProductRepository {
  Future<SellerProductsResponse> getProducts({name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/all"
        "?page=${page}&name=${name}");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return sellerProductsResponseFromJson(response.body);
  }

  remainingUploadProducts() async {
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/products/remaining-uploads");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);
    return remainingProductFromJson(response.body);
  }

  productDuplicateReq({required id}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/duplicate/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productDuplicateResponseFromJson(response.body);
  }

  productDeleteReq({required id}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/delete/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return deleteProductFromJson(response.body);
  }

  productStatusChangeReq({required id, status}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/change-status");

    var post_body = jsonEncode({"id": id, "status": status});
    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response =
        await ApiRequest.post(url: url, headers: reqHeader, body: post_body);

    return deleteProductFromJson(response.body);
  }

  productFeaturedChangeReq({required id, required featured}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/change-featured");

    var post_body = jsonEncode({"id": id, "featured_status": featured});
    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response =
        await ApiRequest.post(url: url, headers: reqHeader, body: post_body);

    return deleteProductFromJson(response.body);
  }

  Future<CategoryResponseSeller> getCategoryRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/categories");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);

    return categoryResponseSellereFromJson(response.body);
  }

  Future<BrandResponseSeller> getBrandRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/brands");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);

    return brandResponseSellerFromJson(response.body);
  }

  Future<BrandResponseSeller> getTaxRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/taxes");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);

    return brandResponseSellerFromJson(response.body);
  }

  Future<AttributeResponse> getAttributeRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/attributes");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);

    return attributeResponseFromJson(response.body);
  }

  Future<ColorResponse> getColorsRes() async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/colors");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json"
    };

    final response = await ApiRequest.get(url: url, headers: reqHeader);

    return colorResponseFromJson(response.body);
  }

  Future<CommonResponseSeller> addProductResponse(postBody) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/products/add");
    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final response =
        await ApiRequest.post(url: url, headers: reqHeader, body: postBody);
    return commonResponseSellerFromJson(response.body);
  }

  Future<CommonResponseSeller> updateProductResponse(
      postBody, productId, lang) async {
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/products/update/$productId?lang=$lang");

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    final response =
        await ApiRequest.post(url: url, headers: reqHeader, body: postBody);

    return commonResponseSellerFromJson(response.body);
  }

  Future<ProductEditResponse> productEdit({required id, lang = "en"}) async {
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/products/edit/$id?lang=$lang");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    return productEditResponseFromJson(response.body);
  }
}
