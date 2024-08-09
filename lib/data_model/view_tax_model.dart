import 'package:active_ecommerce_flutter/data_model/common_dropdown_model.dart';
import 'package:flutter/material.dart';

import '../screens/classified_ads/classified_product_add.dart';

class VatTaxModel{
  String id ,name;
  VatTaxModel(this.id, this.name);
}
class VatTaxViewModel{
  VatTaxModel vatTaxModel;
  TextEditingController amount= TextEditingController(text: "0");
  List<CommonDropDownItem> items;
  CommonDropDownItem? selectedItem;
  VatTaxViewModel(this.vatTaxModel, this.items,{CommonDropDownItem? selectedItem,String? amount}) {
    this.selectedItem= selectedItem ?? items.first;
    this.amount.text=amount??"0";
  }
}