import 'dart:convert';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/screens/classified_ads/classified_product_add.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/custom/aiz_summer_note.dart';
import 'package:active_ecommerce_flutter/custom/buttons.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/lang_text.dart';
import 'package:active_ecommerce_flutter/custom/m_decoration.dart';
import 'package:active_ecommerce_flutter/custom/my_widget.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/attribute_model.dart';
import 'package:active_ecommerce_flutter/data_model/category_model.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/common_dropdown_model.dart';
import 'package:active_ecommerce_flutter/data_model/seller_category_response.dart';
import 'package:active_ecommerce_flutter/data_model/seller_product_response.dart';
import 'package:active_ecommerce_flutter/data_model/state_response.dart';
import 'package:active_ecommerce_flutter/data_model/uploaded_file_list_response.dart';
import 'package:active_ecommerce_flutter/data_model/view_tax_model.dart';
import 'package:active_ecommerce_flutter/helpers/phone_field_helpers.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/styles_helpers.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository_new.dart';
import 'package:active_ecommerce_flutter/screens/seller_section/components/multi_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../../../custom/seller_loading.dart';
import '../../../helpers/text_style_helpers.dart';
import '../file_upload/file_upload_seller.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
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

  // bool isFeatured = false;
  bool isTodaysDeal = false;
  bool isContinue = true;

  List<CategoryModel> categories = [];
  bool isCategoryInit = false;

  List<CommonDropDownItem> brands = [];
  List<VatTaxViewModel> vatTaxList = [];
  List<CommonDropDownItem> videoType = [];
  List<CommonDropDownItem> addToFlashType = [];
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

  CategoryModel? selectedCategory;
  CommonDropDownItem? selectedBrand;

  CommonDropDownItem? selectedVideoType;
  CommonDropDownItem? selectedAddToFlashType;
  CommonDropDownItem? selectedFlashDiscountType;
  CommonDropDownItem? selectedProductDiscountType;
  CommonDropDownItem? selectedColor;
  AttributesModel? selectedAttribute;

  //Product value
  var mainCategoryId;
  List categoryIds = [];
  String? productName,
      // categoryId,
      brandId,
      unit,
      milk,
      age,
      weight,
      minQuantity,
      refundable,
      barcode,
      photos,
      thumbnailImg,
      videoProvider,
      videoLink,
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
      metaDescription,
      metaImg,
      shippingType,
      flatShippingCost,
      lowStockQuantity,
      stockVisibilityState,
      cashOnDelivery,
      estShippingDays,
      button;
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

  ImagePicker pickImage = ImagePicker();

  List<FileInfo> productGalleryImages = [];
  FileInfo? thumbnailImage;
  FileInfo? video;
  FileInfo? metaImage;
  FileInfo? pdfDes;

  DateTimeRange? dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  //Edit text controller
  TextEditingController productNameEditTextController = TextEditingController();
  TextEditingController ageEditTextController = TextEditingController();
  TextEditingController milkEditTextController = TextEditingController();
  TextEditingController pregnancyEditTextController = TextEditingController();
  TextEditingController unitEditTextController = TextEditingController();
  TextEditingController descriptionEditTextController = TextEditingController();
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

  CategoryResponseSeller? categoryResponse;

  void initializeFields() {
    // Initialize fields with default values
    if (shippingConfigurationList.isNotEmpty) {
      selectedShippingConfiguration = shippingConfigurationList.first;
    } else {
      selectedShippingConfiguration =
          CustomRadioModel("Free Shipping", "free", true);
    }

    if (stockVisibilityStateList.isNotEmpty) {
      selectedstockVisibilityState = stockVisibilityStateList.first;
    } else {
      selectedstockVisibilityState =
          CustomRadioModel("Show Stock Quantity", "quantity", true);
    }
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

  getCategories() async {
    categoryResponse = await SellerProductRepository().getCategoryRes();
    categoryResponse!.data!.forEach((element) {
      CategoryModel model = CategoryModel(
          id: element.id.toString(),
          title: element.name,
          icon: element.icon,
          isExpanded: false,
          isSelected: false,
          height: 0.0,
          child: element.child!,
          children: setChildCategory(element.child!));
      categories.add(model);
    });
    if (categories.isNotEmpty) {
      selectedCategory = categories.first;
    }
    isCategoryInit = true;
    setState(() {});
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
    brandsRes.data!.forEach((element) {
      brands.addAll([
        CommonDropDownItem("${element.id}", element.name),
      ]);
    });
    setState(() {});
  }

  getColors() async {
    var colorRes = await SellerProductRepository().getColorsRes();
    colorRes.data!.forEach((element) {
      colorList.add(CommonDropDownItem("${element.code}", "${element.name}"));
    });

    setState(() {});
  }

  getAttributes() async {
    var attributeRes = await SellerProductRepository().getAttributeRes();

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

    // selectedCategory = categories.first;

    setState(() {});
  }

  setConstDropdownValues() {
    videoType.clear();
    videoType.addAll([
      CommonDropDownItem("youtube", LangText(context).local.youtube_ucf),
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

  getTaxType() async {
    var taxRes = await SellerProductRepository().getTaxRes();

    taxRes.data!.forEach((element) {
      vatTaxList.add(
          VatTaxViewModel(VatTaxModel("${element.id}", "${element.name}"), [
        CommonDropDownItem("amount", "Flat"),
        CommonDropDownItem("percent", "Percent"),
      ]));
    });
  }

  fetchAll() {
    getCategories();
    getBrands();
    getTaxType();
    getColors();
    getAttributes();
    // setConstDropdownValues();
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

  Future<XFile?> pickSingleImage() async {
    return await pickImage.pickImage(source: ImageSource.gallery);
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
            productVariations.add(VariationModel(
                colorName! + "-" + element,
                FileInfo(),
                TextEditingController(
                    text: unitPriceEditTextController.text.trim().toString()),
                TextEditingController(text: "0"),
                TextEditingController(),
                false));
          });
        } else {
          productVariations.add(VariationModel(
              colorName,
              FileInfo(),
              TextEditingController(
                  text: unitPriceEditTextController.text.trim().toString()),
              TextEditingController(text: "0"),
              TextEditingController(),
              false));
        }
      });
    } else {
      List<String> attributeList = generateAttributeVariation();

      if (attributeList.isNotEmpty) {
        attributeList.forEach((element) {
          productVariations.add(VariationModel(
              element,
              null,
              TextEditingController(
                  text: unitPriceEditTextController.text.trim().toString()),
              TextEditingController(text: "10"),
              TextEditingController(),
              false));
        });
      }
    }
  }

  setChange() {
    setState(() {});
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
    if (choice_options != null) choice_options.clear();

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
    productName = _selectedProductName;
    if (selectedBrand != null) brandId = selectedBrand!.key;
    milk = milkEditTextController.text.isEmpty
        ? 'null'
        : milkEditTextController.text;
    age = ageEditTextController.text.isEmpty ? '0' : ageEditTextController.text;
    unit = unitEditTextController.text.trim();
    weight = weightEditTextController.text.trim();
    minQuantity = minimumEditTextController.text.trim();

    tagMap.clear();
    tags?.forEach((element) {
      tagMap.add(jsonEncode({"value": '$element'}));
    });

    setProductPhotoValue();
    if (thumbnailImage != null) thumbnailImg = "${thumbnailImage!.id}";

    if (selectedVideoType != null) {
      videoProvider = selectedVideoType!.key;
    } else {
      videoProvider = '';
    }

    videoLink = videoLinkEditTextController.text.trim().toString();

    setColors();
    colorsActive = isColorActive ? "1" : "0";
    unitPrice = unitPriceEditTextController.text.trim().toString();
    dateRange = dateTimeRange!.start.toString() +
            " to " +
            dateTimeRange!.end.toString() ??
        '';

    discount = productDiscountEditTextController.text.trim().toString();
    discountType = selectedProductDiscountType?.key ?? '';
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
    }

    if (pdfDes != null) pdf = "${pdfDes!.id}";
    metaTitle = metaTitleEditTextController.text.trim().toString();
    metaDescription = metaDescriptionEditTextController.text.trim().toString();
    if (metaImage != null) metaImg = "${metaImage!.id}";
    shippingType = selectedShippingConfiguration.key ?? '';
    flatShippingCost =
        flatShippingCostTextEditTextController.text.trim().toString();
    lowStockQuantity =
        lowStockQuantityTextEditTextController.text.trim().toString();
    stockVisibilityState = selectedstockVisibilityState.key ?? '';
    cashOnDelivery = isCashOnDelivery ? "1" : "0";
    estShippingDays = shippingDayEditTextController.text.trim().toString();
    refundable = isRefundable ? "1" : "0";

    setTaxes();
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

  bool requiredFieldVerification() {
    if (_selectedProductName == null) {
      ToastComponent.showDialog("Product Name Required", gravity: Toast.center);
      return false;
    } else if (mainCategoryId == null && categoryIds.isEmpty) {
      ToastComponent.showDialog("Product Category Required",
          gravity: Toast.center);
      return false;
    } else if (ageEditTextController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Age Required", gravity: Toast.center);
      return false;
    }
    // else if (milkEditTextController.text.trim().toString().isEmpty) {
    //   ToastComponent.showDialog("Milk Required", gravity: Toast.center);
    //   return false;
    // } else if (pregnancyEditTextController.text.trim().toString().isEmpty) {
    //   ToastComponent.showDialog("Pregnancy Required", gravity: Toast.center);
    //   return false;
    // }
    // else if (unitEditTextController.text.trim().toString().isEmpty) {
    //   ToastComponent.showDialog("Product Unit Required", gravity: Toast.center);
    //   return false;
    // }
    else if (unitPriceEditTextController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Product Quantity Price Required",
          gravity: Toast.center);
      return false;
    } else if (productQuantityEditTextController.text
        .trim()
        .toString()
        .isEmpty) {
      ToastComponent.showDialog("Product Quantity Required",
          gravity: Toast.center);
      return false;
    } else if (thumbnailImage == null) {
      ToastComponent.showDialog("Product Image Required",
          gravity: Toast.center);
      return false;
    } else if (isContinue == false &&
        _addressController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Product Address Required",
          gravity: Toast.center);
      return false;
    }
    return true;
  }

  submitProduct(String button) async {
    if (!requiredFieldVerification()) {
      return;
    }

    Loading().show();

    await setProductValues();
    setChoiceAtt();
    Map postValue = Map();
    postValue.addAll({
      "name": _selectedProductName,
      "category_id": mainCategoryId,
      "category_ids": [mainCategoryId],
      "brand_id": null,
      "unit": "1",
      "weight": 0.0,
      "min_qty": minQuantity,
      "tags": [[]],
      "photos": 0,
      "thumbnail_img": thumbnailImg,
      "video_provider": videoProvider,
      "video": video != null ? video!.id : "",
      "video_link": "",
      "colors": [],
      "colors_active": 0,
      "choice_attributes": [],
      "choice_no": [],
      "choice": [],
      "unit_price": unitPrice,
      "date_range": int.parse(discount!) <= 0 ? null : dateRange,
      "discount": discount,
      "discount_type": "",
      "current_stock": int.parse(currentStock ?? '0'),
      "sku": sku,
      "external_link": "",
      "external_link_btn": "",
      "description": descriptionEditTextController.text,
      "pdf": null,
      "meta_title": "",
      "meta_description": "",
      "meta_img": null,
      "low_stock_quantity": int.parse(lowStockQuantity ?? '0'),
      "stock_visibility_state": stockVisibilityState,
      "cash_on_delivery": int.parse(cashOnDelivery ?? '0'),
      "est_shipping_days": "",
      "tax_id": taxId,
      "tax": tax,
      "tax_type": ["amount"],
      "button": button,
      "age": int.parse(ageEditTextController.text),
      "milk": milkEditTextController.text,
      "pregnancy": pregnancyEditTextController.text,
      "address": _addressController.text,
      "state_id": 0,
      "city_id": 0,
      "postal_code": 0,
      "latitude": lat,
      "longitude": long,
      "animal": 1
    });
    postValue.addAll(choice_options);
    if (refund_addon_installed.$) {
      postValue.addAll({"refundable": refundable});
    }
    postValue.addAll(makeVariationMap());
    print('postValue ======== > $postValue');
    var postBody = jsonEncode(postValue);
    var response = await SellerProductRepository().addProductResponse(postBody);

    Loading().hide();
    if (response.result) {
      ToastComponent.showDialog(response.message.first, gravity: Toast.center);

      Navigator.pop(context);
    } else {
      dynamic errorMessages = response.message;
      if (errorMessages.runtimeType == String) {
        ToastComponent.showDialog(errorMessages, gravity: Toast.center);
      } else {
        ToastComponent.showDialog(errorMessages.join(","),
            gravity: Toast.center);
      }
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

  List<String> _productName = [];
  String? _selectedProductName;

  void onChangeProductName(String? value) {
    _selectedProductName = value;
    setState(() {});
  }

  @override
  void initState() {
    initializeFields();
    fetchAll();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidht = MediaQuery.of(context).size.width;
    Loading.setInstance(context);
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
            buildMedia(),
          ],
        )),
        bottomNavigationBar: buildBottomAppBar(context),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isContinue
              ? Container(
                  color: MyTheme.accent_color,
                  width: mWidht,
                  child: Buttons(
                      onPressed: () async {
                        if (!requiredFieldVerification()) {
                          return;
                        }
                        ToastComponent.showDialog("Address Required",
                            gravity: Toast.center);
                        isContinue = false;
                        setChange();
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: MyTheme.white),
                      )))
              : Wrap(
                  children: [
                    Container(
                        color: MyTheme.accent_color.withOpacity(0.7),
                        width: mWidht / 2,
                        child: Buttons(
                            onPressed: () async {
                              submitProduct("unpublish");
                            },
                            child: Text(
                              LangText(context).local.save_n_unpublish_ucf,
                              style: TextStyle(color: MyTheme.white),
                            ))),
                    Container(
                        color: MyTheme.accent_color,
                        width: mWidht / 2,
                        child: Buttons(
                            onPressed: () async {
                              submitProduct("publish");
                            },
                            child: Text(
                                LangText(context).local.save_n_publish_ucf,
                                style: TextStyle(color: MyTheme.white))))
                  ],
                )
        ],
      ),
    );
  }

  Widget buildGeneral() {
    return Column(
      children: [
        buildTabViewItem(
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
              buildEditTextField("Age", "Age", ageEditTextController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  isMandatory: true),
              itemSpacer(),
              buildEditTextField("Milk", "Milk", milkEditTextController),
              itemSpacer(),
              buildEditTextField(
                  "Pregnancy", "Pregnancy", pregnancyEditTextController),
              // itemSpacer(),
              // buildEditTextField("Unit", "Unit", unitEditTextController,
              //     keyboardType: TextInputType.number,
              //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              //     isMandatory: true),
              itemSpacer(height: 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMedia() {
    return buildTabViewItem(
      '',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chooseSingleImageField(
              LangText(context).local.image_300_ucf,
              LangText(context).local.thumbnail_image_300_des,
              true,
              "image", (onChosenImage) {
            thumbnailImage = onChosenImage;
            setChange();
          }, thumbnailImage),
          itemSpacer(height: 1),
          chooseSingleImageField(
              LangText(context).local.video_ucf,
              LangText(context).local.video_des,
              false,
              "video", (onChosenImage) {
            video = onChosenImage;
            setChange();
          }, video),
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
          if (isContinue == false)
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text("${LangText(context).local.address_ucf}",
                          style: TextStyle(
                              color: MyTheme.dark_font_grey, fontSize: 12)),
                      Text("*",
                          style: TextStyle(
                              color: MyTheme.brick_red, fontSize: 16)),
                    ],
                  ),
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
                      controller: _addressController,
                      cursorColor: MyTheme.accent_color,
                      decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: LangText(context).local.enter_address_ucf,
                      ),
                      onSubmitted: (value) async {
                        var suggestion = await getSuggestions(value);
                        if (suggestion.isNotEmpty) {
                          _addressController.text = suggestion[0]['description']; // Assuming the first match
                          var placeId = suggestion[0]['place_id'];
                          var details = await getPlaceDetails(placeId);
                          var location = details['geometry']['location'];
                          lat = location['lat'];
                          long = location['lng'];
                          print('lat ------------ > $lat');
                          print('long ------------ > $long');
                          mapController?.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(lat, long),
                            ),
                          );
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
                      _addressController.text = suggestion['description'];
                      var placeId = suggestion['place_id'];
                      var details = await getPlaceDetails(placeId);
                      var location = details['geometry']['location'];
                      lat = location['lat'];
                      long = location['lng'];
                      print('lat ------------ > $lat');
                      print('long ------------ > $long');
                      mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(lat, long),
                        ),
                      );
                    },
                  ),

                ),
                itemSpacer(height: 200)
              ],
            )
        ],
      ),
    );
  }

  Widget buildPriceNStock() {
    return buildTabViewItem(
      "",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildEditTextField(
              LangText(context).local.quantity_ucf,
              LangText(context).local.quantity_ucf,
              productQuantityEditTextController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              isMandatory: true),
          itemSpacer(),
          buildPriceEditTextField(
              LangText(context).local.per_quantity_price_ucf,
              LangText(context).local.per_quantity_price_ucf,
              isMandatory: true),
          itemSpacer(),
        ],
      ),
    );
  }

  Widget buildTabViewItem(String title, Widget children) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppStyles.itemMargin,
        right: AppStyles.itemMargin,
        // top: AppStyles.itemMargin,
      ),
      child: Column(
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
      ),
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

  Widget imageField(
    String shortMessage,
    dynamic onChosenImage,
    String fileType,
    FileInfo? selectedFile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Buttons(
          padding: EdgeInsets.zero,
          onPressed: () async {
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
                    LangText(context).local.browse_ucf,
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
              child: MultiCategory(
                categories: categories,
                isCategoryInit: isCategoryInit,
                onSelectedCategories: (categories) {
                  categoryIds.clear();
                  categoryIds.addAll(categories);
                },
                onSelectedMainCategory: (mainCategory) {
                  _selectedProductName = null;
                  mainCategoryId = mainCategory;
                  _productName.clear();
                  categories.forEach((element) {
                    if (element.id == mainCategory) {
                      element.child!.forEach((element) {
                        _productName.add(element.name ?? '');
                      });
                    }
                  });
                  setChange();
                },
                initialCategoryIds: categoryIds,
                initialMainCategory: mainCategoryId,
              ),
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

  Widget buildPriceEditTextField(String title, String hint,
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
            controller: unitPriceEditTextController,
            onChanged: (string) {
              createProductVariation();
            },
            cursorColor: MyTheme.accent_color,
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
            LangText(context).local.add_new_product_ucf,
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
      //this.id,
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
