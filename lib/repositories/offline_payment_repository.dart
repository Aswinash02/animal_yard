import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/offline_payment_submit_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/middlewares/banned_user.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';

import '../data_model/order_create_response.dart';

class OfflinePaymentRepository {
  // Future<dynamic> getOfflinePaymentSubmitResponse(
  //     {required int? order_id,
  //     required String amount,
  //     required String name,
  //     required String trx_id,
  //     required int? photo}) async {
  //   var post_body = jsonEncode({
  //     "order_id": "$order_id",
  //     "amount": "$amount",
  //     "name": "$name",
  //     "trx_id": "$trx_id",
  //     "photo": "$photo",
  //   });
  //
  //   String url = ("${AppConfig.BASE_URL}/offline/payment/submit");
  //
  //
  //   final response = await ApiRequest.post(
  //       url: url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer ${access_token.$}",
  //         "App-Language": app_language.$!,
  //         "Accept": "application/json",
  //         "System-Key": AppConfig.system_key
  //       },
  //       body: post_body,
  //       middleware: BannedUser());
  //   return offlinePaymentSubmitResponseFromJson(response.body);
  // }

  Future<dynamic> getOfflinePaymentSubmitResponse(
      {method, trx_id, photo, amount, name, addressId}) async {
    var post_body = jsonEncode({
      // "user_id": "${user_id.$}",
      // "payment_type": "${payment_method}"
      "payment_type": "${method}",
      "address_id": addressId,
      "name": "$name",
      "amount": "${amount}",
      "trx_id": "${trx_id}",
      "payment_option": "offline",
      "photo": "${photo}"
    });

    String url = ("${AppConfig.BASE_URL}/payments/pay/cod");

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body,
        middleware: BannedUser());

    return orderCreateResponseFromJson(response.body);
  }
}
