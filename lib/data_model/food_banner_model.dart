class FoodBannerModel {
  String? banner;
  String? link;

  FoodBannerModel({this.banner, this.link});

  FoodBannerModel.fromJson(Map<String, dynamic> json) {
    banner = json['banner'];
    link = json['link'];
  }
}
