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
  TextEditingController unitPriceEditTextController =
      TextEditingController(text: "0");
  TextEditingController productQuantityEditTextController =
      TextEditingController(text: "0");
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
  TextEditingController _TextEditTextController = TextEditingController();

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
          isExpanded: false,
          isSelected: false,
          height: 0.0,
          children: setChildCategory(element.child!));
      categories.add(model);
      _productName.add(model.title ?? '');
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
    // print(images != null);
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
            print(element);
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
    // productName = productNameEditTextController.text.trim();
    print('_selectedProductName ======= $_selectedProductName');
    productName = _selectedProductName;
    if (selectedBrand != null) brandId = selectedBrand!.key;

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
    } else if (selectedCategory == null) {
      ToastComponent.showDialog("Product Category Required",
          gravity: Toast.center);
      return false;
    } else if (minimumEditTextController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Product Minimum Quantity Required",
          gravity: Toast.center);
      return false;
    } else if (unitEditTextController.text.trim().toString().isEmpty) {
      ToastComponent.showDialog("Product Unit Required", gravity: Toast.center);
      return false;
    }
    return true;
  }

  submitProduct(String button) async {
    print('---- tags ${tags}');
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
      "category_ids": categoryIds,
      "brand_id": brandId,
      "unit": unit,
      "weight": weight,
      "min_qty": minQuantity,
      "tags": [tagMap.toString()],
      "photos": photos,
      "thumbnail_img": thumbnailImg,
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
    print('_selected_state!.id ${_selected_state!.id}');
    print('_selected_city!.id ${_selected_city!.id}');
    postValue.addAll({
      "description": descriptionEditTextController.text,
      "pdf": pdf,
      "meta_title": metaTitle,
      "meta_description": metaDescription,
      "meta_img": metaImg,
      "low_stock_quantity": lowStockQuantity,
      "stock_visibility_state": stockVisibilityState,
      "cash_on_delivery": cashOnDelivery,
      "est_shipping_days": estShippingDays,
      "tax_id": taxId,
      "tax": tax,
      "tax_type": taxType,
      "button": button,
      "age": ageEditTextController.text,
      "milk": milkEditTextController.text,
      "pregnancy": pregnancyEditTextController.text,
      "address": _addressController.text,
      "state_id": _selected_state!.id,
      "city_id": _selected_city!.id,
      "postal_code": _postalCodeController.text,
      "lat": lat,
      "long": long,
    });
    print('postValue ====== ${postValue}');
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
        body: SingleChildScrollView(child: buildBodyContainer()),
        bottomNavigationBar: buildBottomAppBar(context),
      ),
    );
  }

  Widget buildBodyContainer() {
    return changeMainContent(_selectedTabIndex);
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  child: Text(LangText(context).local.save_n_publish_ucf,
                      style: TextStyle(color: MyTheme.white))))
        ],
      ),
    );
  }

  changeMainContent(int index) {
    switch (index) {
      case 0:
        return buildGeneral();
        break;
      case 1:
        return buildMedia();
        break;
      case 2:
        return buildPriceNStock();
        break;
      // case 3:
      //   return buildShipping();
      //   break;
      // case 4:
      //   // return buildShipping();
      //   break;
      default:
        return Container();
    }
  }

  Widget buildGeneral() {
    return Column(
      children: [
        buildTabViewItem(
          LangText(context).local.product_information_ucf,
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
                        print('item -------- $item');
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
              buildEditTextField(
                "Age",
                "Age",
                ageEditTextController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                isMandatory: true,
              ),
              itemSpacer(),
              buildEditTextField(
                "Milk",
                "Milk",
                milkEditTextController,
                isMandatory: false,
              ),
              itemSpacer(),
              buildEditTextField(
                "Pregnancy",
                "Pregnancy",
                pregnancyEditTextController,
                isMandatory: false,
              ),
              itemSpacer(),
              buildEditTextField(LangText(context).local.unit_ucf,
                  LangText(context).local.unit_eg_ucf, unitEditTextController,
                  isMandatory: true),
              itemSpacer(),
              buildTagsEditTextField(
                  LangText(context).local.tags_ucf,
                  LangText(context).local.type_and_hit_enter_to_add_a_tag_ucf,
                  tagEditTextController,
                  isMandatory: true),
              if (refund_addon_installed.$)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    itemSpacer(),
                    buildSwitchField(
                        LangText(context).local.refundable_ucf, isRefundable,
                        (value) {
                      isRefundable = value;
                      setChange();
                    }),
                  ],
                ),
              itemSpacer(),
              buildEditTextField(
                  LangText(context).local.product_description_ucf,
                  LangText(context).local.product_description_ucf,
                  descriptionEditTextController,
                  isMandatory: true),
              itemSpacer(),
              buildSwitchField(
                LangText(context).local.cash_on_delivery_ucf,
                isCashOnDelivery,
                (onChanged) {
                  isCashOnDelivery = onChanged;
                  setChange();
                },
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        buildMedia(),
        buildPriceNStock()
      ],
    );
  }

  Widget buildVatTax(title, TextEditingController controller, onChangeDropDown,
      CommonDropDownItem? selectedDropdown, List<CommonDropDownItem> iteams) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          SizedBox(
            width: (mWidht / 2) - 25,
            child: buildEditTextField(title, "0", controller),
          ),
          Spacer(),
          _buildDropDownField("", (newValue) {
            onChangeDropDown(newValue);
            setChange();
          }, selectedDropdown, iteams, width: (mWidht / 2) - 25),
        ],
      ),
    );
  }

  Widget buildMedia() {
    return buildTabViewItem(
      LangText(context).local.product_images_ucf,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chooseGalleryImageField(),
          itemSpacer(),
          chooseSingleImageField(
              LangText(context).local.thumbnail_image_300_ucf,
              LangText(context).local.thumbnail_image_300_des, (onChosenImage) {
            thumbnailImage = onChosenImage;
            setChange();
          }, thumbnailImage),
          itemSpacer(),
          buildEditTextField(
              LangText(context).local.video_link_ucf,
              LangText(context).local.video_link_ucf,
              videoLinkEditTextController),
          itemSpacer(height: 10),
          smallTextForMessage(LangText(context).local.video_link_des),
          itemSpacer(),
          buildGroupItems(
            LangText(context).local.pdf_description_ucf,
            chooseSingleFileField(
                LangText(context).local.pdf_specification_ucf, "",
                (onChosenFile) {
              pdfDes = onChosenFile;
              setChange();
            }, pdfDes),
          ),
          // itemSpacer()
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
          buildPriceEditTextField(LangText(context).local.unit_price_ucf, "0"),
          if (productVariations.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                itemSpacer(),
                buildEditTextField(LangText(context).local.quantity_ucf, "0",
                    productQuantityEditTextController,
                    isMandatory: true),
                itemSpacer(),
                buildEditTextField(
                    LangText(context).local.sku_all_capital,
                    LangText(context).local.sku_all_capital,
                    skuEditTextController),
              ],
            ),
          itemSpacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("${LangText(context).local.address_ucf} *",
                style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12)),
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
                  decoration: InputDecorations.buildInputDecoration_1(
                      hint_text: LangText(context).local.enter_address_ucf)),
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
                List<dynamic> addressComponents = details['address_components'];

                _addressController.text = addressComponents.first['long_name'];
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
          itemSpacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("${LangText(context).local.state_ucf} *",
                style: TextStyle(color: MyTheme.font_grey, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
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
                suggestionsCallback: (name) async {
                  if (_selected_country == null) {
                    var stateResponse = await AddressRepository()
                        .getStateListByCountry(); // blank response
                    return stateResponse.states;
                  }
                  var stateResponse = await AddressRepository()
                      .getStateListByCountry(
                          country_id: _selected_country, name: name);
                  return stateResponse.states;
                },
                loadingBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(LangText(context).local.loading_states_ucf,
                            style: TextStyle(color: MyTheme.medium_grey))),
                  );
                },
                itemBuilder: (context, dynamic state) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      state.name,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(LangText(context).local.no_state_available,
                            style: TextStyle(color: MyTheme.medium_grey))),
                  );
                },
                onSuggestionSelected: (dynamic state) {
                  onSelectStateDuringAdd(state, setState);
                },
                textFieldConfiguration: TextFieldConfiguration(
                    onTap: () {},
                    controller: _stateController,
                    onSubmitted: (txt) {},
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: LangText(context).local.enter_state_ucf)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("${LangText(context).local.city_ucf} *",
                style: TextStyle(color: MyTheme.font_grey, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: MyTheme.white,
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: Color.fromRGBO(255, 255, 255, 0), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: MyTheme.textfield_grey,
                    offset: Offset(0, 6),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: TypeAheadField(
                suggestionsCallback: (name) async {
                  if (_selected_state == null) {
                    var cityResponse = await AddressRepository()
                        .getCityListByState(); // blank response
                    return cityResponse.cities;
                  }
                  var cityResponse = await AddressRepository()
                      .getCityListByState(
                          state_id: _selected_state!.id, name: name);
                  return cityResponse.cities;
                },
                loadingBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(LangText(context).local.loading_cities_ucf,
                            style: TextStyle(color: MyTheme.medium_grey))),
                  );
                },
                itemBuilder: (context, dynamic city) {
                  //print(suggestion.toString());
                  return ListTile(
                    dense: true,
                    title: Text(
                      city.name,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(LangText(context).local.no_city_available,
                            style: TextStyle(color: MyTheme.medium_grey))),
                  );
                },
                onSuggestionSelected: (dynamic city) {
                  onSelectCityDuringAdd(city, setState);
                },
                textFieldConfiguration: TextFieldConfiguration(
                    onTap: () {},
                    //autofocus: true,
                    controller: _cityController,
                    onSubmitted: (txt) {
                      // keep blank
                    },
                    decoration: InputDecorations.buildInputDecoration_1(
                        hint_text: LangText(context).local.enter_city_ucf)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              LangText(context).local.postal_code,
              style: TextStyle(color: MyTheme.font_grey, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MyWidget.customCardView(
              backgroundColor: MyTheme.white,
              elevation: 5,
              width: DeviceInfo(context).width!,
              height: 46,
              borderRadius: 10,
              child: TextField(
                controller: _postalCodeController,
                keyboardType: TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                decoration: InputDecorations.buildInputDecoration_1(
                  hint_text: LangText(context).local.enter_postal_code_ucf,
                ),
                inputFormatters: [
                  PhoneNumberInputFormatter(),
                  LengthLimitingTextInputFormatter(6),
                ],
              ),
            ),
          ),
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

  Widget buildAttributeModelView(
      index,
      attributeName,
      List<CommonDropDownItem> attributesValues,
      selectedValue,
      dynamic onchange,
      dynamic remove) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: mWidht * 0.15, child: buildFieldTitle(attributeName)),
            Container(
              width: mWidht * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: MDecoration.decoration1(),
              child: DropdownButton<CommonDropDownItem>(
                isDense: true,
                underline: Container(),
                isExpanded: true,
                onChanged: (CommonDropDownItem? value) {
                  onchange(value);
                },
                icon: const Icon(Icons.arrow_drop_down),
                value: selectedValue,
                items: attributesValues
                    .map(
                      (value) => DropdownMenuItem<CommonDropDownItem>(
                        value: value,
                        child: Text(
                          value.value!,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              width: mWidht * 0.10,
              child: IconButton(
                  onPressed: () {
                    remove(index);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: MyTheme.brick_red,
                  )),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        buildShowSelectedOptions(
            selectedAttributes[index].selectedAttributeItems, (deleteIndex) {
          selectedAttributes[index]
              .selectedAttributeItems
              .removeAt(deleteIndex);
          setChange();
          createProductVariation();
        })
      ],
    );
  }

  Widget buildGroupItems(groupTitle, Widget children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildGroupTitle(groupTitle),
        itemSpacer(height: 14.0),
        children,
      ],
    );
  }

  Text buildGroupTitle(title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: MyTheme.font_grey),
    );
  }

  Widget chooseGalleryImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LangText(context).local.gallery_images_600,
              style: TextStyle(
                  fontSize: 12,
                  color: MyTheme.font_grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Buttons(
              padding: EdgeInsets.zero,
              onPressed: () {
                pickGalleryImages();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
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
                          style:
                              TextStyle(fontSize: 12, color: MyTheme.grey_153),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          height: 46,
                          width: 80,
                          color: MyTheme.light_grey,
                          child: Text(
                            LangText(context).local.browse_ucf,
                            style: TextStyle(
                                fontSize: 12, color: MyTheme.grey_153),
                          )),
                    ],
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          LangText(context)
              .local
              .these_images_are_visible_in_product_details_page_gallery_600,
          style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
        ),
        SizedBox(
          height: 10,
        ),
        if (productGalleryImages.isNotEmpty)
          Wrap(
            children: List.generate(
              productGalleryImages.length,
              (index) => Stack(
                children: [
                  MyWidget.imageWithPlaceholder(
                      height: 60.0,
                      width: 60.0,
                      url: productGalleryImages[index].url),
                  Positioned(
                    top: 0,
                    right: 5,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: MyTheme.white),
                      child: InkWell(
                        onTap: () {
                          print(index);
                          productGalleryImages.removeAt(index);
                          setState(() {});
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
            ),
          ),
      ],
    );
  }

  Widget chooseSingleImageField(String title, String shortMessage,
      dynamic onChosenImage, FileInfo? selectedFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  color: MyTheme.font_grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            imageField(shortMessage, onChosenImage, selectedFile)
          ],
        ),
      ],
    );
  }

  Widget chooseSingleFileField(String title, String shortMessage,
      dynamic onChosenFile, FileInfo? selectedFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  color: MyTheme.font_grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            fileField("document", shortMessage, onChosenFile, selectedFile)
          ],
        ),
      ],
    );
  }

  Widget buildShowSelectedOptions(
      List<CommonDropDownItem> options, dynamic remove) {
    return SizedBox(
      width: DeviceInfo(context).width! - 34,
      child: Wrap(
        children: List.generate(
            options.length,
            (index) => Container(
                decoration: BoxDecoration(
                    color: MyTheme.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: MyTheme.grey_153)),
                constraints: BoxConstraints(
                    maxWidth: (DeviceInfo(context).width! - 50) / 4),
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                child: Stack(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 20, top: 5, bottom: 5),
                        constraints: BoxConstraints(
                            maxWidth: (DeviceInfo(context).width! - 50) / 4),
                        child: Text(
                          options[index].value.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        )),
                    Positioned(
                      right: 2,
                      child: InkWell(
                        onTap: () {
                          remove(index);
                        },
                        child: Icon(Icons.highlight_remove,
                            size: 15, color: MyTheme.brick_red),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  Widget imageField(
      String shortMessage, dynamic onChosenImage, FileInfo? selectedFile) {
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
                    builder: (context) => const UploadFileSeller(
                          fileType: "image",
                          canSelect: true,
                        ))));
            print("chooseFile.url");
            print(chooseFile.first.url);
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
                  radius: BorderRadius.circular(5),
                  height: 50.0,
                  width: 50.0,
                  url: selectedFile.url),
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

  Widget fileField(String fileType, String shortMessage, dynamic onChosenFile,
      FileInfo? selectedFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Buttons(
          padding: EdgeInsets.zero,
          onPressed: () async {
            // XFile chooseFile = await pickSingleImage();
            List<FileInfo> chooseFile = (await (
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadFileSeller(
                    fileType: fileType,
                    canSelect: true,
                  ),
                ),
              ),
            )) as List<FileInfo>;
            print("chooseFile.url");
            print(chooseFile.first.url);
            if (chooseFile.isNotEmpty) {
              onChosenFile(chooseFile.first);
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
        SizedBox(
          height: 10,
        ),
        if (shortMessage.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            children: [
              Container(
                padding: EdgeInsets.all(3),
                height: 40,
                alignment: Alignment.center,
                width: 40,
                decoration: BoxDecoration(
                  color: MyTheme.grey_153,
                ),
                child: Text(
                  selectedFile.fileOriginalName! +
                      "." +
                      selectedFile.extension!,
                  style: TextStyle(fontSize: 9, color: MyTheme.white),
                ),
              ),
              Positioned(
                top: 0,
                right: 5,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: MyTheme.white),
                  // remove the selected file button
                  child: InkWell(
                    onTap: () {
                      onChosenFile(null);
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

  summerNote(title) {
    if (productDescriptionKey.currentState != null) {
      productDescriptionKey.currentState!.getText().then((value) {
        description = value;
        print(description);
        if (description != null) {
          // productDescriptionKey.currentState.setText(description);
        }
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: MyTheme.font_grey),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 250,
          width: mWidht,
          child: FlutterSummernote(
              showBottomToolbar: false,
              value: description,
              key: productDescriptionKey),
        ),
      ],
    );
    // FlutterSummernote(
    // hint: "Your text here...",
    // key: productDescriptionKey,
    // customToolbar: """
    //         [
    //             ['style', ['bold', 'italic', 'underline', 'clear']],
    //             ['font', ['strikethrough', 'superscript', 'subscript']]
    //         ]"""
    // )
  }

  Widget smallTextForMessage(String txt) {
    return Text(
      txt,
      style: TextStyle(fontSize: 8, color: MyTheme.grey_153),
    );
  }

  Widget itemSpacer({double height = 24}) {
    return SizedBox(
      height: height,
    );
  }

  Widget _buildDropDownField(String title, dynamic onchange,
      CommonDropDownItem? selectedValue, List<CommonDropDownItem> itemList,
      {bool isMandatory = false, double? width}) {
    return buildCommonSingleField(
        title, _buildDropDown(onchange, selectedValue, itemList, width: width),
        isMandatory: isMandatory);
  }

  Widget _buildMultiCategory(String title,
      {bool isMandatory = false, double? width}) {
    return buildCommonSingleField(
        title,
        Container(
            height: 250,
            width: width ?? mWidht,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                  mainCategoryId = mainCategory;
                },
                initialCategoryIds: categoryIds,
                initialMainCategory: mainCategoryId,
              ),
            )),
        isMandatory: isMandatory);
  }

  Widget _buildDropDown(dynamic onchange, CommonDropDownItem? selectedValue,
      List<CommonDropDownItem> itemList,
      {double? width}) {
    return Container(
      height: 46,
      width: width ?? mWidht,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: MDecoration.decoration1(),
      child: DropdownButton<CommonDropDownItem>(
        menuMaxHeight: 300,
        isDense: true,
        underline: Container(),
        isExpanded: true,
        onChanged: (CommonDropDownItem? value) {
          onchange(value);
          print("on Change Working");
        },
        icon: const Icon(Icons.arrow_drop_down),
        value: selectedValue,
        items: itemList
            .map(
              (value) => DropdownMenuItem<CommonDropDownItem>(
                value: value,
                child: Text(
                  value.value!,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildColorDropDown(dynamic onchange,
      CommonDropDownItem? selectedValue, List<CommonDropDownItem> itemList,
      {double? width}) {
    return Container(
      height: 46,
      width: width ?? mWidht,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: MDecoration.decoration1(),
      child: DropdownButton<CommonDropDownItem>(
        menuMaxHeight: 300,
        isDense: true,
        underline: Container(),
        isExpanded: true,
        onChanged: (CommonDropDownItem? value) {
          onchange(value);
        },
        icon: const Icon(Icons.arrow_drop_down),
        value: selectedValue,
        items: itemList
            .map(
              (value) => DropdownMenuItem<CommonDropDownItem>(
                value: value,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          color: Color(
                              int.parse(value.key!.replaceAll("#", "0xFF"))),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    Text(
                      value.value!,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFlatDropDown(String title, dynamic onchange,
      CommonDropDownItems selectedValue, List<CommonDropDownItems> itemList,
      {bool isMandatory = false, double? width}) {
    return buildCommonSingleField(
        title,
        Container(
          height: 46,
          width: width ?? mWidht,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MyTheme.app_accent_color_extra_light),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: DropdownButton<CommonDropDownItems>(
            isDense: true,
            underline: Container(),
            isExpanded: true,
            onChanged: (value) {
              onchange(value);
            },
            icon: const Icon(Icons.arrow_drop_down),
            value: selectedValue,
            items: itemList
                .map(
                  (value) => DropdownMenuItem<CommonDropDownItems>(
                    value: value,
                    child: Text(
                      value.value!,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
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
            decoration: InputDecorations.buildInputDecoration_1(
              hint_text: hint,
            ),
          ),
        ),
        isMandatory: isMandatory,
      ),
    );
  }

  Widget buildTagsEditTextField(
      String title, String hint, TextEditingController textEditingController,
      {isMandatory = false}) {
    //textEditingController.buildTextSpan(context: context, withComposing: true);
    return buildCommonSingleField(
      title,
      Container(
        padding: EdgeInsets.only(top: 14, bottom: 10, left: 14, right: 14),
        alignment: Alignment.centerLeft,
        constraints: BoxConstraints(
          minWidth: DeviceInfo(context).width!,
          minHeight: 46,
        ),
        decoration: MDecoration.decoration1(),
        child: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.start,
          clipBehavior: Clip.antiAlias,
          children: List.generate(tags!.length + 1, (index) {
            if (index == tags!.length) {
              return TextField(
                onSubmitted: (string) {
                  var tag = textEditingController.text
                      .trim()
                      .replaceAll(",", "")
                      .toString();
                  //print("tag empty ${tag.isEmpty}");
                  if (tag.isNotEmpty) addTag(tag);
                },
                onChanged: (string) {
                  if (string.trim().contains(",")) {
                    var tag = string.trim().replaceAll(",", "").toString();
                    //print("tag empty ${tag.isEmpty}");

                    if (tag.isNotEmpty) addTag(tag);
                  }
                },
                controller: textEditingController,
                keyboardType: TextInputType.text,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration.collapsed(
                        hintText: "Type and hit submit",
                        hintStyle: TextStyle(fontSize: 12))
                    .copyWith(constraints: BoxConstraints(maxWidth: 150)),
              );
            }
            return Container(
                decoration: BoxDecoration(
                    color: MyTheme.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 2, color: MyTheme.grey_153)),
                constraints: BoxConstraints(
                    maxWidth: (DeviceInfo(context).width! - 50) / 4),
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 20, top: 5, bottom: 5),
                        constraints: BoxConstraints(
                            maxWidth: (DeviceInfo(context).width! - 50) / 4),
                        child: Text(
                          tags![index].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        )),
                    Positioned(
                      right: 2,
                      child: InkWell(
                        onTap: () {
                          tags!.removeAt(index);
                          setChange();
                        },
                        child: Icon(Icons.highlight_remove,
                            size: 15, color: MyTheme.brick_red),
                      ),
                    )
                  ],
                ));
          }),
        ),
      ),
      isMandatory: isMandatory,
    );
  }

  addTag(String string) {
    if (string.trim().isNotEmpty) {
      tags!.add(string.trim());
    }
    tagEditTextController.clear();
    setChange();
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

  Widget buildFlatEditTextField(
      String title, String hint, TextEditingController textEditingController,
      {isMandatory = false}) {
    return Container(
      child: buildCommonSingleField(
        title,
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MyTheme.app_accent_color_extra_light),
          width: DeviceInfo(context).width,
          height: 45,
          child: TextField(
            controller: textEditingController,
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

  variationViewModel(int index) {
    return buildExpansionTile(index, (onExpand) {
      productVariations[index].isExpended = onExpand;
      setChange();
    }, productVariations[index].isExpended);
  }

  buildExpansionTile(int index, dynamic onExpand, isExpanded) {
    return Container(
      height: isExpanded
          ? productVariations[index].photo == null
              ? 274
              : 334
          : 100,
      decoration: MDecoration.decoration1(),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MyTheme.light_grey),
            constraints: BoxConstraints(),
            child: IconButton(
              splashRadius: 5,
              splashColor: MyTheme.noColor,
              constraints: BoxConstraints(),
              iconSize: 12,
              padding: EdgeInsets.zero,
              onPressed: () {
                isExpanded = !isExpanded;
                onExpand(isExpanded);
              },
              icon: Image.asset(
                isExpanded ? "assets/icon/remove.png" : "assets/icon/add.png",
                color: MyTheme.brick_red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: (mWidht / 3),
                        child: Text(
                          productVariations[index].name!,
                          style: MyTextStyle.smallFontSize()
                              .copyWith(color: MyTheme.font_grey),
                        )),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: MyTheme.app_accent_color_extra_light),
                      width: (mWidht / 3),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller:
                            productVariations[index].priceEditTextController,
                        decoration: InputDecorations.buildInputDecoration_1(
                          hint_text: "0",
                          // borderColor: MyTheme.noColor,
                          // hintTextColor: MyTheme.grey_153
                        ),
                      ),
                    )
                  ],
                ),
                if (isExpanded)
                  Column(
                    children: [
                      itemSpacer(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 80,
                              child: Text(
                                LangText(context).local.sku_all_capital,
                                style: MyTextStyle.smallFontSize()
                                    .copyWith(color: MyTheme.font_grey),
                              )),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: MyTheme.white),
                            width: (mWidht * 0.6),
                            child: TextField(
                              controller: productVariations[index]
                                  .skuEditTextController,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                // fillColor: MyTheme.noColor,
                                hint_text: "sku",
                                // borderColor: MyTheme.grey_153,
                                // hintTextColor: MyTheme.grey_153
                              ),
                            ),
                          )
                        ],
                      ),
                      itemSpacer(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            child: Text(
                              LangText(context).local.quantity_ucf,
                              style: MyTextStyle.smallFontSize()
                                  .copyWith(color: MyTheme.font_grey),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: MyTheme.white),
                            width: (mWidht * 0.6),
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                              keyboardType: TextInputType.number,
                              controller: productVariations[index]
                                  .quantityEditTextController,
                              decoration:
                                  InputDecorations.buildInputDecoration_1(
                                // fillColor: MyTheme.noColor,
                                hint_text: "0",
                                // borderColor: MyTheme.grey_153,
                                // hintTextColor: MyTheme.grey_153
                              ),
                            ),
                          )
                        ],
                      ),
                      itemSpacer(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              LangText(context).local.photo_ucf,
                              style: MyTextStyle.smallFontSize()
                                  .copyWith(color: MyTheme.font_grey),
                            ),
                          ),
                          SizedBox(
                            width: (mWidht * 0.6),
                            child: imageField("", (onChosenImage) {
                              productVariations[index].photo = onChosenImage;
                              setChange();
                            }, productVariations[index].photo),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildSwitchField(String title, value, onChanged, {isMandatory = false}) {
    return Row(
      children: [
        if (title.isNotEmpty) buildFieldTitle(title),
        if (isMandatory)
          Text(
            " *",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: MyTheme.brick_red),
          ),
        const Spacer(),
        Container(
          height: 30,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: MyTheme.green,
          ),
        ),
      ],
    );
  }

  Future<DateTimeRange?> _buildPickDate() async {
    DateTimeRange? p;
    p = await showDateRangePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2050),
        builder: (context, child) {
          return Container(
            width: 500,
            height: 500,
            child: DateRangePickerDialog(
              initialDateRange:
                  DateTimeRange(start: DateTime.now(), end: DateTime.now()),
              saveText: LangText(context).local.select_ucf,
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              firstDate: DateTime.now(),
              lastDate: DateTime.utc(2050),
            ),
          );
        });

    return p;
  }

  Widget buildTapBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildTopTapBarItem(LangText(context).local.general_ucf, 0),
          tabBarDivider(),
          buildTopTapBarItem(LangText(context).local.media_ucf, 1),
          tabBarDivider(),
          buildTopTapBarItem(LangText(context).local.price_n_stock_ucf, 2),
          // tabBarDivider(),
          // buildTopTapBarItem(LangText(context).local.seo_all_capital, 3),
          // tabBarDivider(),
          // buildTopTapBarItem(LangText(context).local.shipping_ucf, 3),
        ],
      ),
    );
  }

  Widget tabBarDivider() {
    return const SizedBox(
      width: 1,
      height: 50,
    );
  }

  Container buildTopTapBarItem(String text, int index) {
    return Container(
        height: 50,
        width: 100,
        color: _selectedTabIndex == index
            ? MyTheme.accent_color
            : MyTheme.accent_color.withOpacity(0.5),
        child: Buttons(
            onPressed: () {
              _selectedTabIndex = index;
              setState(() {});
            },
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.white),
            )));
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
      // bottom: PreferredSize(
      //   preferredSize: Size(mWidht, 50),
      //   child: buildTapBar(),
      // ),
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

// class AttributeItemsModel {
//   List<CommonDropDownItem> attributeItems;
//   List<CommonDropDownItem> selectedAttributeItems;
//   CommonDropDownItem selectedAttributeItem;
//
//   AttributeItemsModel(this.attributeItems, this.selectedAttributeItems,
//       this.selectedAttributeItem);
// }

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

class MHeight {
  double? _height;

  double? get height => _height;

  set height(double? value) {
    _height = value;
  }
}
