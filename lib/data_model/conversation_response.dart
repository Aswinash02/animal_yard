// To parse this JSON data, do
//
//     final conversationResponse = conversationResponseFromJson(jsonString);

import 'dart:convert';

ConversationResponse conversationResponseFromJson(String str) =>
    ConversationResponse.fromJson(json.decode(str));

String conversationResponseToJson(ConversationResponse data) =>
    json.encode(data.toJson());

class ConversationResponse {
  ConversationResponse({
    this.conversation_item_list,
    // this.meta,
    this.success,
    this.status,
    this.unReadCustomer,
    this.unReadSeller,
  });

  List<ConversationItem>? conversation_item_list;

  // Meta? meta;
  bool? success;
  int? status;
  int? unReadCustomer;
  int? unReadSeller;

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    List<ConversationItem> items = List<ConversationItem>.from(
        json["data"].map((x) => ConversationItem.fromJson(x)));

    int unReadCustomer =
        items.fold(0, (sum, item) => sum + (item.unReadCustomer as int));
    int unReadSeller =
        items.fold(0, (sum, item) => sum + (item.unReadSeller as int));

    return ConversationResponse(
      conversation_item_list: items,
      // meta: Meta.fromJson(json["meta"]),
      success: json["success"],
      status: json["status"],
      unReadSeller: unReadSeller,
      unReadCustomer: unReadCustomer,
    );
  }

  Map<String, dynamic> toJson() => {
        "data":
            List<dynamic>.from(conversation_item_list!.map((x) => x.toJson())),
        // "meta": meta!.toJson(),
        "success": success,
        "status": status,
      };
}

class ConversationItem {
  ConversationItem({
    this.id,
    this.receiver_id,
    this.receiver_type,
    this.shop_id,
    this.shop_name,
    this.shop_logo,
    this.title,
    this.sender_viewed,
    this.receiver_viewed,
    this.unReadCustomer,
    this.unReadSeller,
    this.date,
  });

  int? id;
  int? receiver_id;
  String? receiver_type;
  int? shop_id;
  String? shop_name;
  String? shop_logo;
  String? title;
  int? sender_viewed;
  int? receiver_viewed;
  int? unReadCustomer;
  int? unReadSeller;
  DateTime? date;

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    return ConversationItem(
      id: json["id"],
      receiver_id: json["receiver_id"],
      receiver_type: json["receiver_type"],
      shop_id: json["shop_id"],
      shop_name: json["shop_name"],
      shop_logo: json["shop_logo"],
      title: json["title"],
      sender_viewed: json["sender_viewed"],
      receiver_viewed: json["receiver_viewed"],
      unReadCustomer: json["unread_customer"],
      unReadSeller: json["unread_seller"],
      date: DateTime.parse(json["date"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "receiver_id": receiver_id,
        "receiver_type": receiver_type,
        "shop_id": shop_id,
        "shop_name": shop_name,
        "shop_logo": shop_logo,
        "title": title,
        "sender_viewed": sender_viewed,
        "receiver_viewed": receiver_viewed,
        "date": date!.toIso8601String(),
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
