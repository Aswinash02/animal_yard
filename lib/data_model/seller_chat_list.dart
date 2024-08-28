// To parse this JSON data, do
//
//     final ChatListResponse = ChatListResponseFromJson(jsonString);

import 'dart:convert';

ChatListResponse chatListResponseFromJson(String str) =>
    ChatListResponse.fromJson(json.decode(str));

String chatListResponseToJson(ChatListResponse data) =>
    json.encode(data.toJson());

class ChatListResponse {
  ChatListResponse({this.data, this.unReadSeller, this.unReadCustomer});

  List<Chat>? data;
  int? unReadSeller;
  int? unReadCustomer;

  factory ChatListResponse.fromJson(Map<String, dynamic> json) {
    List<Chat> items =
        List<Chat>.from(json["data"].map((x) => Chat.fromJson(x)));

    int unReadCustomer =
        items.fold(0, (sum, item) => sum + (item.unReadCustomer as int));
    int unReadSeller =
        items.fold(0, (sum, item) => sum + (item.unReadSeller as int));

    return ChatListResponse(
      data: items,
      unReadSeller: unReadSeller,
      unReadCustomer: unReadCustomer,
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Chat {
  Chat({
    this.id,
    this.image,
    this.name,
    this.title,
    this.unReadSeller,
    this.unReadCustomer,
  });

  int? id;
  String? image;
  String? name;
  String? title;
  int? unReadSeller;
  int? unReadCustomer;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        title: json["title"],
        unReadCustomer: json["unread_customer"],
        unReadSeller: json["unread_seller"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "title": title,
      };
}
