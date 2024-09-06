class FoodBannerModel {
  String? banner;
  String? link;
  int? categoryId;
  String? categoryName;

  FoodBannerModel({this.banner, this.link});

  FoodBannerModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    link = json['link'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }
}
