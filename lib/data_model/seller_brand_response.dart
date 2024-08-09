import 'dart:convert';

BrandResponseSeller brandResponseSellerFromJson(String str) => BrandResponseSeller.fromJson(json.decode(str));

String brandResponseSellerToJson(BrandResponseSeller data) => json.encode(data.toJson());

class BrandResponseSeller {
  BrandResponseSeller({
    this.data,
  });

  List<Brands>? data;

  factory BrandResponseSeller.fromJson(Map<String, dynamic> json) => BrandResponseSeller(
    data: List<Brands>.from(json["data"].map((x) => Brands.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Brands {
  Brands({
    this.id,
    this.name,
    this.icon,
  });

  int? id;
  String? name;
  String? icon;

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
  };
}