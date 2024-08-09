import 'dart:convert';

SellerProductsResponse sellerProductsResponseFromJson(String str) => SellerProductsResponse.fromJson(json.decode(str));

String sellerProductsResponseToJson(SellerProductsResponse data) => json.encode(data.toJson());

class SellerProductsResponse {
  SellerProductsResponse({
    this.data,
    this.links,
    this.meta,
  });

  List<SellerProduct>? data;
  Links? links;
  Meta? meta;

  factory SellerProductsResponse.fromJson(Map<String, dynamic> json) => SellerProductsResponse(
    data: List<SellerProduct>.from(json["data"].map((x) => SellerProduct.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links!.toJson(),
    "meta": meta!.toJson(),
  };
}

class SellerProduct {
  SellerProduct({
    this.id,
    this.name,
    this.thumbnailImg,
    this.price,
    this.status,
    this.category,
    this.featured,
    this.quantity,
  });

  var id;
  String? name;
  String? thumbnailImg;
  String? price;
  var status;
  String? category;
  var featured;
  var quantity;

  factory SellerProduct.fromJson(Map<String, dynamic> json) => SellerProduct(
    id: json["id"],
    name: json["name"],
    thumbnailImg: json["thumbnail_img"],
    price: json["price"],
    status: json["status"],
    category: json["category"],
    featured: json["featured"],
    quantity: json["current_stock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "thumbnail_img": thumbnailImg,
    "price": price,
    "status": status,
    "category": category,
    "featured": featured,
    "current_stock": quantity,
  };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String? first;
  String? last;
  dynamic prev;
  String? next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}

class CustomRadioModel{
  String title,key;
  bool isActive;

  CustomRadioModel(this.title,this.key, this.isActive);
}