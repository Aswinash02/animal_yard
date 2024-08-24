class AnimalProductModel {
  List<AnimalData>? data;
  PaginationLinks? paginationLinks;
  Meta? meta;
  bool? success;
  int? status;

  AnimalProductModel(
      {this.data, this.paginationLinks, this.meta, this.success, this.status});

  AnimalProductModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AnimalData>[];
      json['data'].forEach((v) {
        data!.add(AnimalData.fromJson(v));
      });
    }
    paginationLinks = json['links'] != null ? PaginationLinks.fromJson(json['links']) : null;
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    success = json['success'];
    status = json['status'];
  }
}

class AnimalData {
  int? id;
  String? slug;
  String? name;
  String? thumbnailImage;
  bool? hasDiscount;
  String? discount;
  String? strokedPrice;
  String? mainPrice;
  int? rating;
  double? lat;
  double? lon;
  String? phone;
  int? sales;
  bool? isWholesale;
  ProductLinks? productLinks;

  AnimalData(
      {this.id,
        this.slug,
        this.name,
        this.thumbnailImage,
        this.hasDiscount,
        this.discount,
        this.strokedPrice,
        this.mainPrice,
        this.rating,
        this.lat,
        this.lon,
        this.phone,
        this.sales,
        this.isWholesale,
        this.productLinks});

  AnimalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    thumbnailImage = json['thumbnail_image'];
    hasDiscount = json['has_discount'];
    discount = json['discount'];
    strokedPrice = json['stroked_price'];
    mainPrice = json['main_price'];
    rating = json['rating'];
    lat= (json['lat'] as num?)?.toDouble();
    lon=(json['lon'] as num?)?.toDouble();
    phone = json['phone'];
    sales = json['sales'];
    isWholesale = json['is_wholesale'];
    productLinks = json['links'] != null ? ProductLinks.fromJson(json['links']) : null;
  }
}

class ProductLinks {
  String? details;

  ProductLinks({this.details});

  ProductLinks.fromJson(Map<String, dynamic> json) {
    details = json['details'];
  }
}

class PaginationLinks {
  String? first;
  String? last;
  String? prev;
  String? next;

  PaginationLinks({this.first, this.last, this.prev, this.next});

  PaginationLinks.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<MetaLinks>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = <MetaLinks>[];
      json['links'].forEach((v) {
        links!.add(MetaLinks.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }
}

class MetaLinks {
  String? url;
  String? label;
  bool? active;

  MetaLinks({this.url, this.label, this.active});

  MetaLinks.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }
}
