import 'package:active_ecommerce_flutter/data_model/seller_category_response.dart';

class CategoryModel {
  String? id;
  String? name;
  String? icon;
  String? title;
  bool? isExpanded = false;
  bool? isSelected;
  double? height;
  int? level;
  String? levelText;
  String? parentLevel;
  List<CategoryModel> children;
  List<Categories>? child;

  CategoryModel(
      {this.id,
      this.name,
      this.icon,
      this.title,
      this.isExpanded,
      this.isSelected,
      this.children = const [],
      this.child,
      this.height,
      this.level,
      this.parentLevel,
      this.levelText});

  setLevelText() {
    String tmpTxt = "";
    for (int i = 0; i < level!; i++) {
      tmpTxt += "–";
    }
    levelText = "$tmpTxt $levelText";
  }
}
