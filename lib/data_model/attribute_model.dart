import '../screens/classified_ads/classified_product_add.dart';
import 'common_dropdown_model.dart';

class AttributesModel {
  CommonDropDownItem name;
  List<CommonDropDownItem> attributeItems = [];
  List<CommonDropDownItem> selectedAttributeItems;
  CommonDropDownItems? selectedAttributeItem;

  AttributesModel(this.name, this.attributeItems, this.selectedAttributeItems,
      this.selectedAttributeItem);
}