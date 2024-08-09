class CategoryModel {
  String? id;
  String? name;
  String? title;
  bool? isExpanded = false;
  bool? isSelected;
  double? height;
  int? level;
  String? levelText;
  String? parentLevel;
  List<CategoryModel> children;

  CategoryModel(
      {this.id,
      this.name,
      this.title,
      this.isExpanded,
      this.isSelected,
      this.children = const [],
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
