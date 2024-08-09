
import 'dart:convert';

CommonResponseSeller commonResponseSellerFromJson(String str) => CommonResponseSeller.fromJson(json.decode(str));

String commonResponseSellerToJson(CommonResponseSeller data) => json.encode(data.toJson());
class CommonResponseSeller {
  CommonResponseSeller({
    required this.result,
    required this.message,
  });

  bool result;
  List<String> message;

  factory CommonResponseSeller.fromJson(Map<String, dynamic> json) => CommonResponseSeller(
    result: json["result"],
    message: json["message"] is List
        ? List<String>.from(json["message"].map((x) => x))
        : [json["message"]],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": List<dynamic>.from(message.map((x) => x)),
  };
}