import 'dart:async';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/animal_product_response.dart';
import 'package:active_ecommerce_flutter/data_model/slider_response.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/flash_deal_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/sliders_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class HomePresenter extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int current_slider = 0;
  ScrollController? allProductScrollController;
  ScrollController? featuredCategoryScrollController;
  ScrollController mainScrollController = ScrollController();

  late AnimationController pirated_logo_controller;
  late Animation pirated_logo_animation;

  List<AIZSlider> carouselImageList = [];
  List<AIZSlider> bannerOneImageList = [];
  var bannerTwoImageList = [];
  var featuredCategoryList = [];

  bool isCategoryInitial = true;

  bool isCarouselInitial = true;
  bool isBannerOneInitial = true;
  bool isBannerTwoInitial = true;

  var featuredProductList = [];
  bool isFeaturedProductInitial = true;
  int? totalFeaturedProductData = 0;
  int featuredProductPage = 1;
  bool showFeaturedLoadingContainer = false;

  var bestSellingProductList = [];
  bool isBestSellingProductInitial = true;

  // int? totalBestSellingProductData = 0;
  int bestSellingProductPage = 1;
  bool showBestSellingLoadingContainer = false;

  bool isTodayDeal = false;
  bool isFlashDeal = false;

  var allProductList = [];
  List<AnimalData> animalProductList = [];
  bool isAllProductInitial = true;
  int? totalAllProductData = 0;
  int allProductPage = 1;
  bool showAllLoadingContainer = false;
  int cartCount = 0;

  String? foodBannerImage = '';
  String? foodCategoryName = '';
  int? foodCategoryId = 0;
  String? foodSlug = '';
  bool loadingState = false;

  fetchAll() {
    // fetchCarouselImages();
    // fetchBannerOneImages();
    // fetchBannerTwoImages();
    fetchFoodBannerImages();
    fetchFeaturedCategories();
    // fetchFeaturedProducts();
    // fetchBestSellingProducts();
    // fetchAllProducts();
    fetchAllAnimalProducts();
    // fetchTodayDealData();
    // fetchFlashDealData();
  }

  fetchTodayDealData() async {
    var deal = await ProductRepository().getTodaysDealProducts();
    // print(deal.products!.length);
    if (deal.success! && deal.products!.isNotEmpty) {
      isTodayDeal = true;
      notifyListeners();
    }
  }

  fetchFlashDealData() async {
    var deal = await FlashDealRepository().getFlashDeals();

    if (deal.success! && deal.flashDeals!.isNotEmpty) {
      isFlashDeal = true;
      notifyListeners();
    }
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders!.forEach((slider) {
      carouselImageList.add(slider);
    });
    isCarouselInitial = false;
    notifyListeners();
  }

  fetchBannerOneImages() async {
    var bannerOneResponse = await SlidersRepository().getBannerOneImages();
    bannerOneResponse.sliders!.forEach((slider) {
      bannerOneImageList.add(slider);
    });
    isBannerOneInitial = false;
    notifyListeners();
  }

  fetchFoodBannerImages() async {
    loadingState = true;
    var bannerOneResponse = await SlidersRepository().getFoodBannerImage();
    foodBannerImage = bannerOneResponse.banner;
    foodSlug = bannerOneResponse.link;
    foodCategoryName = bannerOneResponse.categoryName;
    foodCategoryId = bannerOneResponse.categoryId;
    loadingState = false;
    notifyListeners();
  }

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SlidersRepository().getBannerTwoImages();
    bannerTwoResponse.sliders!.forEach((slider) {
      bannerTwoImageList.add(slider);
    });
    isBannerTwoInitial = false;
    notifyListeners();
  }

  fetchFeaturedCategories() async {
    featuredCategoryList.clear();
    var categoryResponse = await CategoryRepository().getFeturedCategories();

    if (categoryResponse.categories != null) {
      for (var category in categoryResponse.categories!) {
        if (!featuredCategoryList
            .any((existingCategory) => existingCategory.id == category.id)) {
          featuredCategoryList.add(category);
        }
      }
    }

    isCategoryInitial = false;
    notifyListeners();
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: featuredProductPage,
    );
    featuredProductPage++;
    featuredProductList.addAll(productResponse.products!);
    isFeaturedProductInitial = false;
    totalFeaturedProductData = productResponse.meta!.total;
    showFeaturedLoadingContainer = false;
    notifyListeners();
  }

  fetchBestSellingProducts() async {
    bestSellingProductList.clear();
    var productResponse = await ProductRepository().getBestSellingProducts();
    bestSellingProductList.addAll(productResponse.products!);
    isBestSellingProductInitial = false;
    // totalBestSellingProductData = productResponse.meta!.total;
    showBestSellingLoadingContainer = false;
    notifyListeners();
  }

  fetchAllProducts() async {
    var productResponse =
        await ProductRepository().getFilteredProducts(page: allProductPage);
    // if (productResponse.products!.isEmpty) {
    //   ToastComponent.showDialog("No more products!", gravity: Toast.center);
    //   return;
    // }

    allProductList.addAll(productResponse.products!);
    isAllProductInitial = false;
    totalAllProductData = productResponse.meta!.total;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  fetchAllAnimalProducts() async {
    animalProductList.clear();
    var productResponse = await ProductRepository().fetchAllAnimalProducts();
    if (productResponse.data != null) {
      print('home ======== > ${productResponse.data!.length}');
      for (var product in productResponse.data!) {
        if (!animalProductList
            .any((existingProduct) => existingProduct.id == product.id)) {
          animalProductList.add(product);
        }
      }
    }
    isAllProductInitial = false;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  reset() {
    carouselImageList.clear();
    bannerOneImageList.clear();
    bannerTwoImageList.clear();
    featuredCategoryList.clear();
    bestSellingProductList.clear();

    isCarouselInitial = true;
    isBannerOneInitial = true;
    isBannerTwoInitial = true;
    isCategoryInitial = true;
    cartCount = 0;

    resetFeaturedProductList();
    resetBestSellingProductList();
    resetAllProductList();
  }

  Future<void> onRefresh() async {
    reset();
    fetchAll();
  }

  resetFeaturedProductList() {
    featuredProductList.clear();
    isFeaturedProductInitial = true;
    totalFeaturedProductData = 0;
    featuredProductPage = 1;
    showFeaturedLoadingContainer = false;
    notifyListeners();
  }

  resetBestSellingProductList() {
    bestSellingProductList.clear();
    isBestSellingProductInitial = true;
    // totalBestSellingProductData = 0;
    bestSellingProductPage = 1;
    showBestSellingLoadingContainer = false;
    notifyListeners();
  }

  resetAllProductList() {
    allProductList.clear();
    isAllProductInitial = true;
    totalAllProductData = 0;
    allProductPage = 1;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  mainScrollListener() {
    mainScrollController.addListener(() {
      if (mainScrollController.position.pixels ==
          mainScrollController.position.maxScrollExtent) {
        allProductPage++;
        ToastComponent.showDialog("More Products Loading...",
            gravity: Toast.center);
        // showAllLoadingContainer = true;
        fetchAllProducts();
        fetchAllAnimalProducts();
      }
    });
  }

  initPiratedAnimation(vnc) {
    pirated_logo_controller =
        AnimationController(vsync: vnc, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
        CurvedAnimation(
            curve: Curves.bounceOut, parent: pirated_logo_controller));

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  // incrementFeaturedProductPage(){
  //   featuredProductPage++;
  //   notifyListeners();
  //
  // }

  incrementCurrentSlider(index) {
    current_slider = index;
    notifyListeners();
  }

  // void dispose() {
  //   pirated_logo_controller.dispose();
  //   notifyListeners();
  // }
  //

  @override
  void dispose() {
    // TODO: implement dispose
    pirated_logo_controller.dispose();
    notifyListeners();
    super.dispose();
  }
}
