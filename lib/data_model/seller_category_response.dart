import 'dart:convert';

CategoryResponseSeller categoryResponseSellereFromJson(String str) => CategoryResponseSeller.fromJson(json.decode(str));

String categoryResponseSellereToJson(CategoryResponseSeller data) => json.encode(data.toJson());

class CategoryResponseSeller {
  CategoryResponseSeller({
    this.data,
  });

  List<Categories>? data;

  factory CategoryResponseSeller.fromJson(Map<String, dynamic> json) => CategoryResponseSeller(
    data: List<Categories>.from(json["data"].map((x) => Categories.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Categories {
  Categories({
    this.id,
    this.parentId,
    this.level,
    this.name,
    this.banner,
    this.icon,
    this.featured,
    this.digital,
    this.child,
  });

  var id;
  var parentId;
  var level;
  String? name;
  String? banner;
  String? icon;
  bool? featured;
  bool? digital;
  List<Categories>? child;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    id: json["id"],
    parentId: json["parent_id"],
    level: int.parse(json["level"].toString()),
    name: json["name"],
    banner: json["banner"],
    icon: json["icon"],
    featured: json["featured"],
    digital: json["digital"],
    child: List<Categories>.from(json["child"].map((x) => Categories.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "level": level,
    "name": name,
    "banner": banner,
    "icon": icon,
    "featured": featured,
    "digital": digital,
    "child": List<dynamic>.from(child!.map((x) => x.toJson())),
  };
}
