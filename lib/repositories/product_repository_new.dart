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
    //print("product res  "+response.body.toString());
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
    //print("product res  "+response.body.toString());
    return remainingProductFromJson(response.body);
  }

  productDuplicateReq({required id}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/duplicate/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    //print("product res  "+response.body.toString());
    return productDuplicateResponseFromJson(response.body);
  }

  productDeleteReq({required id}) async {
    String url = ("${AppConfig.BASE_URL_WITH_PREFIX}/product/delete/$id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    //print("product res  "+response.body.toString());
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

    //print("product res  "+response.body.toString());
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

    //print("product res  "+response.body.toString());
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
    //print("product res  "+response.body.toString());

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
    //print("product res  "+response.body.toString());

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
    //print("product res  "+response.body.toString());

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
    //print("product res  "+response.body.toString());

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
    //print("product res  "+response.body.toString());

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

    print(postBody);
    //print(access_token.$);

    final response =
        await ApiRequest.post(url: url, headers: reqHeader, body: postBody);

    print("product res  " + response.body.toString());

    return commonResponseSellerFromJson(response.body);
  }

  Future<CommonResponseSeller> updateProductResponse(
      postBody, productId, lang) async {
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/products/update/$productId?lang=$lang");
    //print(url.toString());

    var reqHeader = {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    //print(productId);
    //print(postBody);
    //print(access_token.$);

    final response =
        await ApiRequest.post(url: url, headers: reqHeader, body: postBody);

    //print("product res  "+response.body.toString());

    return commonResponseSellerFromJson(response.body);
  }

  Future<ProductEditResponse> productEdit({required id, lang = "en"}) async {
    String url =
        ("${AppConfig.BASE_URL_WITH_PREFIX}/products/edit/$id?lang=$lang");
    print('access_token ${access_token.$}');
    print("product url " + url.toString());
    print("id " + id.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Authorization": "Bearer ${access_token.$}",
    });
    print("product res===========   " + response.body.toString());
    print("product res statuscode " + response.statusCode.toString());
    return productEditResponseFromJson(response.body);
  }
}
