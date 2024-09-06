import 'dart:async';
import 'dart:convert';
import 'package:active_ecommerce_flutter/custom/buttons.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/my_widget.dart';
import 'package:active_ecommerce_flutter/data_model/attribute_model.dart';
import 'package:active_ecommerce_flutter/data_model/category_model.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/file_upload/file_upload_seller.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/uploaded_file_list_response.dart';
import 'package:active_ecommerce_flutter/data_model/view_tax_model.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:toast/toast.dart';
import '../../../custom/aiz_summer_note.dart';
import '../../../custom/input_decorations.dart';
import '../../../custom/lang_text.dart';
import '../../../custom/m_decoration.dart';
import '../../../custom/toast_component.dart';
import '../../../data_model/city_response.dart';
import '../../../data_model/language_list_response.dart';
import '../../../data_model/product_edit_seller_response.dart';
import '../../../data_model/seller_category_response.dart';
import '../../../data_model/seller_product_response.dart';
import '../../../data_model/state_response.dart';
import '../../../helpers/shared_value_helper.dart';
import '../../../helpers/styles_helpers.dart';
import '../../../helpers/text_style_helpers.dart';
import '../../../my_theme.dart';
import '../../../repositories/language_repository.dart';
import '../../../repositories/product_repository_new.dart';
import '../../classified_ads/classified_product_add.dart';
import '../components/multi_category.dart';
import '../../../custom/seller_loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProduct extends StatefulWidget {
  final productId;

  UpdateProduct({Key? key, this.productId}) : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  // double variables

  String _statAndEndTime = "Select Date";

  GoogleMapController? mapController;

  // static const String googleApiKey = 'YOUR_API_KEY';
  static const CameraPosition initialPosition =
      CameraPosition(target: LatLng(37.77483, -122.41942), zoom: 10);

  City? _selected_city;
  int _selected_country = 101;
  MyState? _selected_state;

  double mHeight = 0.0, mWidht = 0.0;
  double lat = 0.0;
  double long = 0.0;
  int _selectedTabIndex = 0;
  bool isColorActive = false;
  bool isRefundable = false;
  bool isCashOnDelivery = false;
  bool isProductQuantityMultiply = false;
  bool isFeatured = false;
  bool isTodaysDeal = false;
  bool isShowStockQuantity = false;
  bool isShowStockWithTextOnly = false;
  bool isHideStock = false;

  bool isCategoryInit = false;
  List<CategoryModel> categories = [];
  List<Language> languages = [];
  List<CommonDropDownItem> brands = [];
  List<VatTaxViewModel> vatTaxList = [];
  List<CommonDropDownItem> videoType = [];
  List<CommonDropDownItem> discountTypeList = [];
  List<CommonDropDownItem> colorList = [];
  List<CommonDropDownItem> selectedColors = [];
  List<AttributesModel> attribute = [];
  List<AttributesModel> selectedAttributes = [];
  List<VariationModel> productVariations = [];
  List<CustomRadioModel> shippingConfigurationList = [];
  List<CustomRadioModel> stockVisibilityStateList = [];
  late CustomRadioModel selectedShippingConfiguration;
  late CustomRadioModel selectedstockVisibilityState;

  CommonDropDownItem? selectedBrand;
  Language? selectedLanguage;

  CommonDropDownItem? selectedVideoType;
  CommonDropDownItem? selectedAddToFlashType;
  CommonDropDownItem? selectedFlashDiscountType;
  CommonDropDownItem? selectedProductDiscountType;
  CommonDropDownItem? selectedColor;
  AttributesModel? selectedAttribute;
  FlutterSummernote? summernote;

  //Product value

  List<String> tmpColorList = [];
  List<ChoiceOptions> tmpAttribute = [];
  String? tmpCategory = "";
  String? tmpBrand = "";
  bool isProductDetailsInit = false;

  List categoryIds = [];
  String? productName,
      categoryId,
      brandId,
      unit,
      weight,
      minQuantity,
      refundable,
      barcode,
      photos,
      thumbnailImg,
      videoProvider,
      videoLink,
      milk,
      colorsActive,
      unitPrice,
      dateRange,
      discount,
      discountType,
      currentStock,
      sku,
      externalLink,
      externalLinkBtn,
      description,
      pdf,
      metaTitle,
      slug,
      metaDescription,
      metaImg,
      shippingType,
      flatShippingCost,
      lowStockQuantity,
      stockVisibilityState,
      cashOnDelivery,
      estShippingDays,
      button;
  String? lang = "en";
  var tagMap = [];
  List<String?>? tags = [],
      colors,
      choiceAttributes,
      choiceNo,
      choice,
      choiceOptions2,
      choiceOptions1,
      taxId,
      tax,
      taxType;

  Map choice_options = Map();

  //ImagePicker pickImage = ImagePicker();

  List<FileInfo> productGalleryImages = [];
  FileInfo? thumbnailImage;
  FileInfo? video;
  FileInfo? metaImage;
  FileInfo? pdfDes;
  DateTimeRange? dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  //Edit text controller
  TextEditingController productNameEditTextController = TextEditingController();
  TextEditingController unitEditTextController = TextEditingController();
  TextEditingController descriptionEditTextController = TextEditingController();
  TextEditingController ageEditTextController = TextEditingController();
  TextEditingController milkEditTextController = TextEditingController();
  TextEditingController kgEditTextController = TextEditingController();
  TextEditingController pregnancyEditTextController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController weightEditTextController =
      TextEditingController(text: "0.0");
  TextEditingController minimumEditTextController =
      TextEditingController(text: "1");
  TextEditingController tagEditTextController = TextEditingController();
  TextEditingController barcodeEditTextController = TextEditingController();
  TextEditingController taxEditTextController = TextEditingController();
  TextEditingController videoLinkEditTextController = TextEditingController();
  TextEditingController metaTitleEditTextController = TextEditingController();
  TextEditingController slugEditTextController = TextEditingController();
  TextEditingController metaDescriptionEditTextController =
      TextEditingController();
  TextEditingController shippingDayEditTextController = TextEditingController();
  TextEditingController productDiscountEditTextController =
      TextEditingController(text: "0");
  TextEditingController flashDiscountEditTextController =
      TextEditingController();
  TextEditingController unitPriceEditTextController = TextEditingController();
  TextEditingController productQuantityEditTextController =
      TextEditingController();
  TextEditingController skuEditTextController = TextEditingController();
  TextEditingController externalLinkEditTextController =
      TextEditingController();
  TextEditingController externalLinkButtonTextEditTextController =
      TextEditingController();
  TextEditingController stockLowWarningTextEditTextController =
      TextEditingController();
  TextEditingController variationPriceTextEditTextController =
      TextEditingController();
  TextEditingController variationQuantityTextEditTextController =
      TextEditingController();
  TextEditingController variationSkuTextEditTextController =
      TextEditingController();
  TextEditingController flatShippingCostTextEditTextController =
      TextEditingController();
  TextEditingController lowStockQuantityTextEditTextController =
      TextEditingController(text: "1");

  GlobalKey<FlutterSummernoteState> productDescriptionKey = GlobalKey();

  getCategories(productInfo) async {
    var categoryResponse = await SellerProductRepository().getCategoryRes();
    categoryResponse.data!.forEach((element) {
      CategoryModel model = CategoryModel(
          id: element.id.toString(),
          title: element.name,
          icon: element.icon,
          isExpanded: false,
          isSelected: false,
          height: 0.0,
          child: element.child!,
          children: setChildCategory(categoryResponse.data!));
      categories.add(model);
    });

    categories.forEach((element) {
      if (element.id == categoryId?.toString()) {
        element.child!.forEach((element) {
          _productName.add(element.name ?? '');
        });
      }
    });
    isCategoryInit = true;
    _selectedProductName = productInfo.productName ?? '';
    setState(() {});
  }

  Future<List> getSuggestions(String input) async {
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=${OtherConfig.GOOGLE_MAP_API_KEY}';
    var response = await http.get(Uri.parse(request));
    var json = jsonDecode(response.body);
    var predictions = json['predictions'];
    return predictions;
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$baseUrl?placeid=$placeId&key=${OtherConfig.GOOGLE_MAP_API_KEY}';
    var response = await http.get(Uri.parse(request));
    var json = jsonDecode(response.body);
    var result = json['result'];
    return result;
  }

  List<CategoryModel> setChildCategory(List<Categories> child) {
    List<CategoryModel> list = [];
    child.forEach((element) {
      var children = element.child ?? [];
      CategoryModel model = CategoryModel(
          id: element.id.toString(),
          title: element.name,
          height: 0.0,
          children: children.isNotEmpty ? setChildCategory(children) : []);

      list.add(model);
    });
    return list;
  }

  getBrands() async {
    var brandsRes = await SellerProductRepository().getBrandRes();
    brands.clear();
    brandsRes.data!.forEach((element) {
      brands.addAll([
        CommonDropDownItem("${element.id}", element.name),
      ]);
    });

    if (tmpBrand != null && tmpBrand!.isNotEmpty && brands.isNotEmpty) {
      brands.forEach((element) {
        if (element.key == tmpBrand) {
          selectedBrand = element;
        }
      });
    }

    setState(() {});
  }

  getColors() async {
    var colorRes = await SellerProductRepository().getColorsRes();
    colorList.clear();

    colorRes.data!.forEach((element) {
      colorList.add(CommonDropDownItem("${element.code}", "${element.name}"));
    });

    selectedColors.clear();

    colorList.forEach((element) {
      if (tmpColorList.contains(element.key)) {
        selectedColors.add(element);
      }
    });

    setState(() {});
  }

  getAttributes() async {
    var attributeRes = await SellerProductRepository().getAttributeRes();
    attribute.clear();

    selectedAttributes.clear();

    attributeRes.data!.forEach((element) {
      attribute.add(
        AttributesModel(
          CommonDropDownItem("${element.id}", "${element.name}"),
          List.generate(
              element.values!.length,
              (index) => CommonDropDownItem("${element.values![index].id}",
                  "${element.values![index].value}")),
          [],
          null,
        ),
      );
    });

    tmpAttribute.forEach((tmpElement) {
      attribute.forEach((attributeElement) {
        if (attributeElement.name.key == tmpElement.attributeId) {
          List<CommonDropDownItem> items = [];

          tmpElement.values!.forEach((tmpItems) {
            attributeElement.attributeItems.forEach((attributeItems) {
              if (tmpItems == attributeItems.value) {
                items.add(attributeItems);
              }
            });
          });
          selectedAttributes.add(AttributesModel(attributeElement.name,
              attributeElement.attributeItems, items, null));
        }
      });
    });
    setState(() {});
  }

  setConstDropdownValues() {
    videoType.clear();
    videoType.addAll([
      CommonDropDownItem("youtube", LangText(context).local!.youtube_ucf),
      CommonDropDownItem(
          "dailymotion", LangText(context).local.dailymotion_ucf),
      CommonDropDownItem("vimeo", LangText(context).local.vimeo_ucf),
    ]);
    selectedVideoType = videoType.first;

    discountTypeList.clear();
    discountTypeList.addAll([
      CommonDropDownItem("amount", "Flat"),
      CommonDropDownItem("percent", "Percent"),
    ]);
    selectedProductDiscountType = discountTypeList.first;
    selectedFlashDiscountType = discountTypeList.first;
    // selectedCategory = categories.first;
    shippingConfigurationList.clear();
    shippingConfigurationList.addAll([
      CustomRadioModel("Free Shipping", "free", true),
      CustomRadioModel("Flat Rate", "flat_rate", false),
    ]);
    stockVisibilityStateList.clear();
    stockVisibilityStateList.addAll([
      CustomRadioModel("Show Stock Quantity", "quantity", true),
      CustomRadioModel("Show Stock With Text Only", "text", false),
      CustomRadioModel("Hide Stock", "hide", false)
    ]);

    selectedShippingConfiguration = shippingConfigurationList.first;
    selectedstockVisibilityState = stockVisibilityStateList.first;

    setState(() {});
  }

  getTaxType(ProductInfo productInfo) async {
    var taxRes = await SellerProductRepository().getTaxRes();
    vatTaxList.clear();
    taxRes.data!.forEach((element) {
      var tmpTax = productInfo.tax!
          .where((productTax) => productTax.taxId == element.id);

      if (tmpTax.isNotEmpty) {
        var taxList = [
          CommonDropDownItem("amount", "Flat"),
          CommonDropDownItem("percent", "Percent")
        ];
        CommonDropDownItem selectedTax = taxList
            .where((element) => element.key == tmpTax.first.taxType)
            .first;

        vatTaxList.add(
          VatTaxViewModel(
              VatTaxModel("${element.id}", "${element.name}"), taxList,
              selectedItem: selectedTax, amount: tmpTax.first.tax?.toString()),
        );
      } else {
        vatTaxList.add(
          VatTaxViewModel(
            VatTaxModel("${element.id}", "${element.name}"),
            [
              CommonDropDownItem("amount", "Flat"),
              CommonDropDownItem("percent", "Percent"),
            ],
          ),
        );
      }
    });
  }

  pickGalleryImages() async {
    var tmp = productGalleryImages;
    List<FileInfo>? images = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadFileSeller(
                  fileType: "image",
                  canSelect: true,
                  canMultiSelect: true,
                  prevData: tmp,
                )));
    if (images != null) {
      productGalleryImages = images;
      setChange();
    }
  }

  createProductVariation() {
    productVariations.clear();

    if (selectedColors.isNotEmpty) {
      selectedColors.forEach((colors) {
        // add attribute with color;
        var colorName = colors.value;
        List<String> attributeList = generateAttributeVariation();
        if (attributeList.isNotEmpty) {
          attributeList.forEach((element) {
            String variationName = colorName! + "-" + element;
            productVariations.add(VariationModel(
                variationName,
                FileInfo(),
                TextEditingController(
                    text: unitPriceEditTextController.text.trim().toString()),
                TextEditingController(text: "0"),
                TextEditingController(text: variationName),
                false));
          });
        } else {
          String? variationName = colorName;
          productVariations.add(VariationModel(
              variationName,
              FileInfo(),
              TextEditingController(
                  text: unitPriceEditTextController.text.trim().toString()),
              TextEditingController(text: "0"),
              TextEditingController(text: variationName),
              false));
        }
      });
    } else {
      List<String> attributeList = generateAttributeVariation();

      if (attributeList.isNotEmpty) {
        attributeList.forEach((element) {
          String variationName = element;
          productVariations.add(VariationModel(
              variationName,
              null,
              TextEditingController(
                  text: unitPriceEditTextController.text.trim().toString()),
              TextEditingController(text: "10"),
              TextEditingController(text: variationName),
              false));
        });
      }
    }
  }

  setInitialProductVariation(Stock stock) {
    productVariations.clear();

    if (stock.data!.isNotEmpty) {
      stock.data!.forEach(
        (element) {
          FileInfo? image;
          if (element.image!.data!.isNotEmpty) {
            image = element.image!.data!.first;
          }

          productVariations.add(VariationModel(
              element.variant,
              image == null ? null : image,
              TextEditingController(text: element.price?.toString()),
              TextEditingController(text: element.qty?.toString()),
              TextEditingController(text: element.sku),
              false));
        },
      );
    }

    setChange();
  }

  List<String> generateAttributeVariation() {
    var variationColumn = 1;

    selectedAttributes.forEach((element) {
      if (element.selectedAttributeItems.isNotEmpty) {
        variationColumn =
            variationColumn * element.selectedAttributeItems.length;
      }
    });

    List<String> mList = [];

    for (int i = 0; i < selectedAttributes.length; i++) {
      for (int j = 0;
          j < selectedAttributes[i].selectedAttributeItems.length;
          j++) {
        if (i == 0) {
          for (int k = 0;
              k <
                  (variationColumn /
                      selectedAttributes[i].selectedAttributeItems.length);
              k++) {
            var value = selectedAttributes[i]
                .selectedAttributeItems[j]
                .value!
                .replaceAll(" ", "");
            mList.add(value);
          }
        } else {
          for (int l = j;
              l < mList.length;
              l = l + selectedAttributes[i].selectedAttributeItems.length) {
            String tmp = mList[l] +
                "-" +
                selectedAttributes[i]
                    .selectedAttributeItems[j]
                    .value!
                    .replaceAll(" ", "");
            mList[l] = tmp;
          }
        }
      }
    }

    return mList;
  }

  setProductPhotoValue() {
    photos = "";
    for (int i = 0; i < productGalleryImages.length; i++) {
      if (i != (productGalleryImages.length - 1)) {
        photos = "$photos " + "${productGalleryImages[i].id},";
      } else {
        photos = "$photos " + "${productGalleryImages[i].id}";
      }
    }
  }

  setColors() {
    colors = [];
    selectedColors.forEach((element) {
      colors!.add(element.key);
    });
  }

  setChoiceAtt() {
    choiceAttributes = [];
    choiceNo = [];
    choice = [];
    choice_options.clear();

    selectedAttributes.forEach((element) {
      choiceAttributes!.add(element.name.key);
      choiceNo!.add(element.name.key);
      choice!.add(element.name.value);

      List<String?> tmpValue = [];
      element.selectedAttributeItems.forEach((attributes) {
        tmpValue.add(attributes.value);
      });
      choice_options.addAll({"choice_options_${element.name.key}": tmpValue});
    });

    choiceAttributes!.sort();
  }

  setTaxes() {
    taxType = [];
    tax = [];
    taxId = [];
    vatTaxList.forEach((element) {
      taxId!.add(element.vatTaxModel.id);
      tax!.add(element.amount.text.trim().toString());
      if (element.selectedItem != null) taxType!.add(element.selectedItem!.key);
    });
  }

  setProductValues() async {
    productName = productNameEditTextController.text.trim();

    if (selectedBrand != null) brandId = selectedBrand!.key;

    unit = unitEditTextController.text.trim();
    weight = weightEditTextController.text.trim();
    minQuantity = minimumEditTextController.text.trim();

    tagMap.clear();
    tags!.forEach((element) {
      tagMap.add(jsonEncode({"value": '$element'}));
    });
    // add product photo
    setProductPhotoValue();
    if (thumbnailImage != null) thumbnailImg = "${thumbnailImage!.id}";

    videoProvider = selectedVideoType!.key;
    videoLink = videoLinkEditTextController.text.trim().toString();
    milk = categoryId == "1"
        ? milkEditTextController.text
        : kgEditTextController.text;
    //Set colors
    setColors();
    colorsActive = isColorActive ? "1" : "0";
    unitPrice = unitPriceEditTextController.text.trim().toString();
    dateRange = dateTimeRange!.start.toString() +
        " to " +
        dateTimeRange!.end.toString();
    discount = productDiscountEditTextController.text.trim().toString();
    discountType = selectedProductDiscountType!.key;
    currentStock = productVariations.isEmpty
        ? productQuantityEditTextController.text.trim().toString()
        : "0";
    sku = productVariations.isEmpty
        ? skuEditTextController.text.trim().toString()
        : null;
    externalLink = externalLinkEditTextController.text.trim().toString();
    externalLinkBtn =
        externalLinkButtonTextEditTextController.text.trim().toString();

    if (productDescriptionKey.currentState != null) {
      description = await productDescriptionKey.currentState!.getText() ?? "";
      description = await productDescriptionKey.currentState!.getText() ?? "";
    }

    if (pdfDes != null) pdf = "${pdfDes!.id}";
    metaTitle = metaTitleEditTextController.text.trim().toString();
    slug = slugEditTextController.text.trim().toString();

    metaDescription = metaDescriptionEditTextController.text.trim().toString();
    if (metaImage != null) metaImg = "${metaImage!.id}";
    shippingType = selectedShippingConfiguration.key;
    flatShippingCost =
        flatShippingCostTextEditTextController.text.trim().toString();
    lowStockQuantity =
        lowStockQuantityTextEditTextController.text.trim().toString();
    stockVisibilityState = selectedstockVisibilityState.key;
    cashOnDelivery = isCashOnDelivery ? "1" : "0";
    estShippingDays = shippingDayEditTextController.text.trim().toString();
    // get taxes
    refundable = isRefundable ? "1" : "0";
    setTaxes();
  }

  bool requiredFieldVerification() {
    if (_selectedProductName == null) {
      ToastComponent.showDialog("Product Name Required", gravity: Toast.center);
      return false;
    } else if (categoryId == null && categoryIds.isEmpty) {
      ToastComponent.showDialog("Product Category Required");
      return false;
    } else if (ageEditTextController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Age Required");
      return false;
    }
    // else if (milkEditTextController.text.trim().toString().isEmpty) {
    //   ToastComponent.showDialog("Milk Required");
    //   return false;
    // } else if (pregnancyEditTextController.text.trim().toString().isEmpty) {
    //   ToastComponent.showDialog("Pregnancy Required");
    //   return false;
    // }
    else if (thumbnailImage == null) {
      ToastComponent.showDialog("Product Image Required");
      return false;
    }

    // else if (unitEditTextController.text.trim().toString().isEmpty) {
    //   ToastComponent.showDialog("Product Unit Required");
    //   return false;
    // }
    else if (unitPriceEditTextController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Product Quantity Price Required");
      return false;
    } else if (productQuantityEditTextController.text
        .trim()
        .toString()
        .isEmpty) {
      ToastComponent.showDialog("Product Quantity Required");
      return false;
    } else if (_addressController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Product Address Required",
          gravity: Toast.center);
      return false;
    }
    return true;
  }

  submitProduct() async {
    if (!requiredFieldVerification()) {
      return;
    }

    Loading().show();

    await setProductValues();

    setChoiceAtt();
    Map postValue = Map();
    postValue.addAll({
      "name": _selectedProductName,
      "category_id": categoryId,
      "category_ids": [categoryId],
      "brand_id": brandId,
      "unit": "1",
      "weight": weight,
      "min_qty": minQuantity,
      "tags": [tagMap.toString()],
      "photos": photos,
      "thumbnail_img": thumbnailImg,
      "video": video != null ? video!.id : "",
      "video_provider": videoProvider,
      "video_link": videoLink,
      "colors": colors,
      "colors_active": colorsActive,
      "choice_attributes": choiceAttributes,
      "choice_no": choiceNo,
      "choice": choice
    });

    postValue.addAll(choice_options);

    if (refund_addon_installed.$) {
      postValue.addAll({"refundable": refundable});
    }

    postValue.addAll({
      "unit_price": unitPrice,
      "date_range": int.parse(discount!) <= 0 ? null : dateRange,
      "discount": discount,
      "discount_type": discountType,
      "current_stock": currentStock,
      "sku": sku,
      "external_link": externalLink,
      "external_link_btn": externalLinkBtn,
    });
    postValue.addAll(makeVariationMap());

    if (carrier_base_shipping.$) {
      postValue.addAll({
        "shipping_type": shippingType,
        "flat_shipping_cost": flatShippingCost
      });
    }
    postValue.addAll({
      "description": descriptionEditTextController.text,
      "pdf": pdf,
      "meta_title": metaTitle,
      "meta_description": metaDescription,
      "meta_img": metaImg,
      "slug": slug,
      "low_stock_quantity": lowStockQuantity,
      "stock_visibility_state": stockVisibilityState,
      "cash_on_delivery": cashOnDelivery,
      "est_shipping_days": estShippingDays,
      "tax_id": taxId,
      "tax": tax,
      "tax_type": taxType,
      "button": button,
      "age": ageEditTextController.text,
      "milk": milk == ""
          ? ""
          : categoryId == "1"
              ? "$milk ltr"
              : "$milk kg",
      "pregnancy": pregnancyEditTextController.text,
      "address": _addressController.text,
      "state_id": _selected_state!.id,
      "city_id": _selected_city!.id,
      "postal_code": _postalCodeController.text,
      "latitude": lat,
      "longitude": long,
      "animal": 1
    });
    var postBody = jsonEncode(postValue);
    var response = await SellerProductRepository()
        .updateProductResponse(postBody, widget.productId, lang);

    Loading().hide();
    if (response.result) {
      List errorMessages = response.message;
      ToastComponent.showDialog(errorMessages.join(","), gravity: Toast.center);

      Navigator.pop(context);
    } else {
      List errorMessages = response.message;
      ToastComponent.showDialog(errorMessages.join(","), gravity: Toast.center);
    }
  }

  Map makeVariationMap() {
    Map variation = Map();
    productVariations.forEach((element) {
      variation.addAll({
        "price_" + element.name!.replaceAll(" ", "-"):
            element.priceEditTextController.text.trim().toString() ?? null,
        "sku_" + element.name!.replaceAll(" ", "-"):
            element.skuEditTextController.text.trim().toString() ?? null,
        "qty_" + element.name!.replaceAll(" ", "-"):
            element.quantityEditTextController.text.trim().toString() ?? null,
        "img_" + element.name!.replaceAll(" ", "-"):
            element.photo == null ? null : element.photo!.id,
      });
    });
    return variation;
  }

  onSelectStateDuringAdd(state, setModalState) {
    if (_selected_state != null && state.id == _selected_state!.id) {
      setModalState(() {
        _stateController.text = state.name;
      });
      return;
    }
    _selected_state = state;
    _selected_city = null;
    setState(() {});
    setModalState(() {
      _stateController.text = state.name;
      _cityController.text = "";
    });
  }

  onSelectCityDuringAdd(city, setModalState) {
    if (_selected_city != null && city.id == _selected_city!.id) {
      setModalState(() {
        _cityController.text = city.name;
      });
      return;
    }
    _selected_city = city;
    setModalState(() {
      _cityController.text = city.name;
    });
  }

  setInitialValue(ProductInfo productInfo) async {
    selectedLanguage =
        languages.where((element) => element.code == productInfo.lang).first;
    setConstDropdownValues();
    isColorActive = productInfo.colors!.isNotEmpty;
    isRefundable = productInfo.refundable == 1 ? true : false;

    isCashOnDelivery = productInfo.cashOnDelivery == 1 ? true : false;

    isProductQuantityMultiply =
        productInfo.isQuantityMultiplied == 1 ? true : false;
    isTodaysDeal = productInfo.todaysDeal == 1 ? true : false;
    tmpColorList.addAll(productInfo.colors!);
    getColors();
    lat = productInfo.latitude ?? 0.0;
    long = productInfo.longitude ?? 0.0;
    tmpAttribute.clear();
    tmpAttribute.addAll(productInfo.choiceOptions!);
    getAttributes();
    if (productInfo.choiceOptions!.isNotEmpty) {
      setInitialProductVariation(productInfo.stocks!);
    }

    shippingConfigurationList.forEach((element) {
      element.isActive = false;
      if (element.key == productInfo.shippingType) {
        selectedShippingConfiguration = element;
        element.isActive = true;
        flatShippingCostTextEditTextController.text =
            productInfo.shippingCost!.toString();
      }
    });

    stockVisibilityStateList.forEach((element) {
      element.isActive = false;
      if (element.key == productInfo.stockVisibilityState) {
        selectedstockVisibilityState = element;
        element.isActive = true;
      }
    });

    categoryId = productInfo.categoryId?.toString();
    categoryIds.addAll(productInfo.categories);
    getCategories(productInfo);

    tmpBrand = productInfo.brandId?.toString();
    getBrands();

    videoType.forEach((element) {
      if (element.key == productInfo.videoProvider) {
        selectedVideoType = element;
      }
    });

    getTaxType(productInfo);

    discountTypeList.forEach((element) {
      if (productInfo.discountType == element.key) {
        selectedProductDiscountType = element;
      }
    });
    if (productInfo.photos!.data!.isNotEmpty) {
      productGalleryImages.addAll(productInfo.photos!.data!);
    }
    if (productInfo.thumbnailImg!.data!.isNotEmpty) {
      thumbnailImage = productInfo.thumbnailImg!.data!.first;
    }
    if (productInfo.video!.data!.isNotEmpty) {
      video = productInfo.video!.data!.first;
    }
    if (productInfo.metaImg!.data!.isNotEmpty) {
      metaImage = productInfo.metaImg!.data!.first;
    }
    if (productInfo.pdf!.data!.isNotEmpty) {
      pdfDes = productInfo.pdf!.data!.first;
    }

    var start = DateTime.tryParse(productInfo.discountStartDate)!;
    var end = DateTime.tryParse(productInfo.discountEndDate)!;
    dateTimeRange = DateTimeRange(start: start, end: end);

    _statAndEndTime =
        intl.DateFormat('d/MM/y').format(dateTimeRange!.start).toString() +
            " - " +
            intl.DateFormat('d/MM/y').format(dateTimeRange!.end).toString();
    tags!.clear();
    if (productInfo.tags!.isNotEmpty) {
      tags!.addAll(productInfo.tags!.split(","));
    }
    unitEditTextController.text = productInfo.productUnit ?? '';
    weightEditTextController.text =
        productInfo.weight == null ? '' : productInfo.weight.toString();
    minimumEditTextController.text =
        productInfo.minQty == null ? '' : productInfo.minQty.toString();
    barcodeEditTextController.text = productInfo.barcode ?? "";
    videoLinkEditTextController.text = productInfo.videoLink ?? "";
    metaTitleEditTextController.text = productInfo.metaTitle ?? '';
    slugEditTextController.text = productInfo.slug ?? '';
    metaDescriptionEditTextController.text = productInfo.metaDescription ?? '';
    shippingDayEditTextController.text = productInfo.estShippingDays ?? "";
    productDiscountEditTextController.text =
        productInfo.discount == null ? '' : productInfo.discount.toString();
    _addressController.text = productInfo.address ?? '';
    _postalCodeController.text = productInfo.postalCode ?? '';
    ageEditTextController.text =
        productInfo.age == '0' ? '' : productInfo.age ?? '';
    if (categoryId == "1") {
      milkEditTextController.text =
          (productInfo.milk ?? '').replaceAll('ltr', '');
    } else {
      kgEditTextController.text = (productInfo.milk ?? '').replaceAll('Kg', '');
    }

    pregnancyEditTextController.text = productInfo.pregnancy ?? '';
    _selected_state = MyState(
        id: productInfo.stateId,
        country_id: _selected_country,
        name: productInfo.state);
    _selected_city = City(
        id: productInfo.cityId,
        state_id: productInfo.stateId,
        name: productInfo.city);
    _cityController.text = productInfo.city ?? '';
    _stateController.text = productInfo.state ?? '';

    unitPriceEditTextController.text = productInfo.unitPrice!.toString();

    if (productInfo.choiceOptions!.isEmpty) {
      productQuantityEditTextController.text =
          productInfo.stocks!.data!.first.qty!.toString();
      skuEditTextController.text = productInfo.stocks!.data!.first.sku ?? "";
    }

    externalLinkEditTextController.text = productInfo.externalLink ?? "";
    externalLinkButtonTextEditTextController.text =
        productInfo.externalLinkBtn ?? '';

    stockLowWarningTextEditTextController.text =
        productInfo.stockVisibilityState!.toString();

    lowStockQuantityTextEditTextController.text =
        productInfo.lowStockQuantity.toString() ?? "";
    descriptionEditTextController.text = productInfo.description ?? "";

    setChange();
  }

  getProductCurrentValues() async {
    if (selectedLanguage != null) {
      lang = selectedLanguage!.code;
    } else {
      lang = languages.first.code;
    }

    await Future.delayed(Duration.zero);
    Loading.setInstance(context);
    Loading().show();

    var productResponse = await SellerProductRepository()
        .productEdit(id: widget.productId, lang: lang);

    Loading().hide();
    if (productResponse.result!) {
      isProductDetailsInit = true;
      setInitialValue(productResponse.data!);
    }
  }

  Future getLanguages() async {
    var languageListResponse = await LanguageRepository().getLanguageList();
    languages.addAll(languageListResponse.languages!);

    setChange();

    return;
  }

  List<String> _productName = [];
  String? _selectedProductName;

  void onChangeProductName(String? value) {
    _selectedProductName = value;
    setState(() {});
  }

  @override
  void initState() {
    getLanguages().then((value) {
      getProductCurrentValues();
    });
    // TODO: implement initState
    super.initState();
  }

  void _onSelectedMainCategory(String mainCategory) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectedProductName = null;
      categoryId = mainCategory;
      _productName.clear();
      categories.forEach((element) {
        if (element.id == categoryId) {
          element.child!.forEach((element) {
            _productName.add(element.name ?? '');
          });
        }
      });
      setChange(); // Calls setState() safely after the build phase.
    });
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;
    if (Loading.getInstance() == null) {
      Loading.setInstance(context);
    }
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: buildAppBar(context) as PreferredSizeWidget?,
        body: SingleChildScrollView(
            child: Column(
          children: [
            buildGeneral(),
            buildPriceNStock(),
          ],
        )),
        bottomNavigationBar: buildBottomAppBar(context),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
          color: MyTheme.accent_color.withOpacity(0.7),
          width: mWidht,
          child: Buttons(
              onPressed: () async {
                submitProduct();
              },
              child: Text(
                LangText(context).local.update_now_ucf,
                style: TextStyle(color: MyTheme.white),
              ))),
    );
  }

  Widget buildGeneral() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppStyles.itemMargin,
        right: AppStyles.itemMargin,
        top: AppStyles.itemMargin,
      ),
      child: buildTabViewItem(
        '',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMultiCategory(LangText(context).local.categories_ucf,
                isMandatory: true),
            itemSpacer(),
            Container(
              child: buildCommonSingleField(
                LangText(context).local.product_name_ucf,
                MyWidget.customCardView(
                  backgroundColor: MyTheme.white,
                  elevation: 5,
                  width: DeviceInfo(context).width!,
                  height: 46,
                  borderRadius: 10,
                  child: DropdownButtonFormField(
                    value: _selectedProductName,
                    onChanged: onChangeProductName,
                    items: _productName.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: LangText(context).local.product_name_ucf,
                    ),
                  ),
                ),
                isMandatory: true,
              ),
            ),
            itemSpacer(),
            buildEditTextField(LangText(context).local.age_ucf,
                LangText(context).local.age_ucf, ageEditTextController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                isMandatory: true),
            itemSpacer(),
            categoryId == "1"
                ? buildEditTextField(LangText(context).local.milk_ucf,
                    LangText(context).local.milk_ucf, milkEditTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[r0-9 .]')),
                      ])
                : buildEditTextField(LangText(context).local.kg_ucf,
                    LangText(context).local.kg_ucf, kgEditTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[r0-9 .]')),
                      ]),
            itemSpacer(),
            buildEditTextField(
              LangText(context).local.pregnancy_ucf,
              LangText(context).local.pregnancy_ucf,
              pregnancyEditTextController,
            ),
            // itemSpacer(),
            // buildEditTextField("Unit", "Unit", unitEditTextController,
            //     keyboardType: TextInputType.number,
            //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //     isMandatory: true),
            itemSpacer(height: 1),
          ],
        ),
      ),
    );
  }

  Widget buildPriceNStock() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppStyles.itemMargin,
        right: AppStyles.itemMargin,
      ),
      child: buildTabViewItem(
        "",
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildEditTextField(
                LangText(context).local.quantity_ucf,
                LangText(context).local.quantity_ucf,
                productQuantityEditTextController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                isMandatory: true),
            itemSpacer(),
            buildPriceEditTextField(
                LangText(context).local.per_quantity_price_ucf,
                LangText(context).local.per_quantity_price_ucf,
                unitPriceEditTextController,
                isMandatory: true),
            itemSpacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chooseSingleImageField(
                    AppLocalizations.of(context)!.image_300_ucf,
                    AppLocalizations.of(context)!.thumbnail_image_300_des,
                    true,
                    "image", (onChosenImage) {
                  thumbnailImage = onChosenImage;
                  setChange();
                }, thumbnailImage),
                itemSpacer(),
                chooseSingleImageField(
                    LangText(context).local.video_ucf,
                    LangText(context).local.video_des,
                    false,
                    "video", (onChosenImage) {
                  video = onChosenImage;
                  setChange();
                }, video),
              ],
            ),
            itemSpacer(),
            Container(
              child: buildCommonSingleField(
                LangText(context).local.product_description_ucf,
                MyWidget.customCardView(
                  backgroundColor: MyTheme.white,
                  elevation: 5,
                  width: DeviceInfo(context).width!,
                  height: 75,
                  borderRadius: 10,
                  child: TextField(
                      controller: descriptionEditTextController,
                      maxLines: 3,
                      cursorColor: MyTheme.accent_color,
                      decoration: InputDecoration(
                          hintText:
                              LangText(context).local.product_description_ucf,
                          filled: true,
                          fillColor: MyTheme.white,
                          hintStyle: TextStyle(
                              fontSize: 12.0, color: MyTheme.textfield_grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyTheme.textfield_grey, width: 0.2),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyTheme.accent_color, width: 0.5),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: MyTheme.textfield_grey, width: 0.2),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(6.0),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10))),
                ),
              ),
            ),
            itemSpacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("${LangText(context).local.address_ucf}",
                  style:
                      TextStyle(color: MyTheme.dark_font_grey, fontSize: 12)),
            ),
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: MyTheme.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: MyTheme.textfield_grey,
                    offset: Offset(0, 6),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  cursorColor: MyTheme.accent_color,
                  controller: _addressController,
                  decoration: InputDecorations.buildInputDecoration_1(
                    hint_text: LangText(context).local.enter_address_ucf,
                  ),
                  onSubmitted: (value) async {
                    var suggestions = await getSuggestions(value);

                    if (suggestions.isNotEmpty) {
                      var matchingSuggestion = suggestions.firstWhere(
                        (suggestion) => suggestion['description'] == value,
                        orElse: () => null,
                      );

                      if (matchingSuggestion != null) {
                        var placeId = matchingSuggestion['place_id'];
                        var details = await getPlaceDetails(placeId);
                        _addressController.text =
                            matchingSuggestion['description'];
                        var location = details['geometry']['location'];
                        lat = location['lat'];
                        long = location['lng'];
                        mapController?.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(lat, long),
                          ),
                        );
                      }
                    }
                  },
                ),
                suggestionsCallback: (pattern) async {
                  return await getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['description']),
                  );
                },
                onSuggestionSelected: (suggestion) async {
                  var placeId = suggestion['place_id'];
                  var details = await getPlaceDetails(placeId);
                  _addressController.text = suggestion['description'];
                  var location = details['geometry']['location'];
                  lat = location['lat'];
                  long = location['lng'];
                  mapController?.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(lat, long),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget buildTabViewItem(String title, Widget children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MyTheme.font_grey),
          ),
        const SizedBox(
          height: 16,
        ),
        children,
      ],
    );
  }

  Widget chooseSingleImageField(
      String title,
      String shortMessage,
      bool isMandatory,
      String fileType,
      dynamic onChosenImage,
      FileInfo? selectedFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 12,
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.bold),
                ),
                if (isMandatory)
                  Text(
                    '*',
                    style: TextStyle(
                        fontSize: 12,
                        color: MyTheme.brick_red,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            imageField(shortMessage, onChosenImage, fileType, selectedFile)
          ],
        ),
      ],
    );
  }

  Widget imageField(String shortMessage, dynamic onChosenImage, String fileType,
      FileInfo? selectedFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Buttons(
          padding: EdgeInsets.zero,
          onPressed: () async {
            // XFile chooseFile = await pickSingleImage();
            List<FileInfo> chooseFile = await (Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadFileSeller(
                          fileType: fileType,
                          canSelect: true,
                        ))));
            if (chooseFile.isNotEmpty) {
              onChosenImage(chooseFile.first);
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: MyWidget().myContainer(
            width: DeviceInfo(context).width!,
            height: 46,
            borderRadius: 6.0,
            borderColor: MyTheme.light_grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Text(
                    LangText(context).local.choose_file,
                    style: TextStyle(fontSize: 12, color: MyTheme.grey_153),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 46,
                  width: 80,
                  color: MyTheme.light_grey,
                  child: Text(
                    LangText(context).local!.browse_ucf,
                    style: TextStyle(fontSize: 12, color: MyTheme.grey_153),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (shortMessage.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                shortMessage,
                style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        if (selectedFile != null)
          Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 60,
                width: 70,
              ),
              MyWidget.imageWithPlaceholder(
                  border: Border.all(width: 0.5, color: MyTheme.light_grey),
                  fileType: fileType,
                  radius: BorderRadius.circular(5),
                  height: 50.0,
                  width: 50.0,
                  url: fileType == "video"
                      ? selectedFile.thumbnail
                      : selectedFile.url),
              Positioned(
                top: 3,
                right: 2,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: MyTheme.light_grey),
                  child: InkWell(
                    onTap: () {
                      onChosenImage(null);
                    },
                    child: Icon(
                      Icons.close,
                      size: 12,
                      color: MyTheme.brick_red,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void setChange() {
    setState(() {});
  }

  Widget itemSpacer({double height = 24}) {
    return SizedBox(
      height: height,
    );
  }

  Widget _buildMultiCategory(String title,
      {bool isMandatory = false, double? width}) {
    return buildCommonSingleField(
        title,
        Container(
            width: width ?? mWidht,
            padding:
                const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 20),
            decoration: MDecoration.decoration1(),
            child: SingleChildScrollView(
              child: isProductDetailsInit
                  ? MultiCategory(
                      isCategoryInit: isCategoryInit,
                      categories: categories,
                      onSelectedCategories: (categories) {
                        categoryIds.clear();
                        categoryIds.addAll(categories);
                      },
                      onSelectedMainCategory: (mainCategory) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _selectedProductName = null;
                          categoryId = mainCategory;
                          _productName.clear();
                          categories.forEach((element) {
                            if (element.id == categoryId) {
                              element.child!.forEach((element) {
                                _productName.add(element.name ?? '');
                              });
                            }
                          });
                          setChange(); // Calls setState() safely after the build phase.
                        });
                      },
                      initialCategoryIds: categoryIds,
                      initialMainCategory: categoryId,
                    )
                  : SizedBox.shrink(),
            )),
        isMandatory: isMandatory);
  }

  Widget buildEditTextField(
      String title, String hint, TextEditingController textEditingController,
      {isMandatory = false,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType}) {
    return Container(
      child: buildCommonSingleField(
        title,
        MyWidget.customCardView(
          backgroundColor: MyTheme.white,
          elevation: 5,
          width: DeviceInfo(context).width!,
          height: 46,
          borderRadius: 10,
          child: TextField(
            controller: textEditingController,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            cursorColor: MyTheme.accent_color,
            decoration: InputDecorations.buildInputDecoration_1(
              hint_text: hint,
            ),
          ),
        ),
        isMandatory: isMandatory,
      ),
    );
  }

  Widget buildPriceEditTextField(
      String title, String hint, TextEditingController textEditingController,
      {isMandatory = false}) {
    return Container(
      child: buildCommonSingleField(
        title,
        MyWidget.customCardView(
          backgroundColor: MyTheme.white,
          elevation: 5,
          width: DeviceInfo(context).width!,
          height: 46,
          borderRadius: 10,
          child: TextField(
            controller: textEditingController,
            cursorColor: MyTheme.accent_color,
            onChanged: (string) {
              createProductVariation();
            },
            keyboardType: TextInputType.number,
            decoration: InputDecorations.buildInputDecoration_1(
              hint_text: hint,
            ),
          ),
        ),
        isMandatory: isMandatory,
      ),
    );
  }

  buildCommonSingleField(title, Widget child, {isMandatory = false}) {
    return Column(
      children: [
        Row(
          children: [
            buildFieldTitle(title),
            if (isMandatory)
              Text(
                " *",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.brick_red),
              ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        child,
      ],
    );
  }

  Text buildFieldTitle(title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: MyTheme.font_grey),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      leadingWidth: 0.0,
      centerTitle: false,
      elevation: 0.0,
      title: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            child: IconButton(
              splashRadius: 15,
              padding: EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            LangText(context).local.update_product_ucf,
            style: MyTextStyle().appbarText(),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class VariationModel {
  String? name;

  FileInfo? photo;
  TextEditingController priceEditTextController,
      quantityEditTextController,
      skuEditTextController;
  bool isExpended;

  VariationModel(
      this.name,
      this.photo,
      this.priceEditTextController,
      this.quantityEditTextController,
      this.skuEditTextController,
      this.isExpended);
}

class Tags {
  static List<String> tags = [];

  static toJson() {
    Map<String, String> map = {};

    tags.forEach((element) {
      map.addAll({"value": element});
    });

    return map;
  }

  static string() {
    return jsonEncode(toJson());
  }
}
