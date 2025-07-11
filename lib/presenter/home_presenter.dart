import 'dart:async';

import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/data_model/slider_response.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/flash_deal_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/sliders_repository.dart';
import 'package:flutter/material.dart';

import '../data_model/flash_deal_response.dart';
import '../single_banner/model.dart';

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
  List<AIZSlider> flashDealBannerImageList = [];
  List<FlashDealResponseDatum> _banners = [];

  List<FlashDealResponseDatum> get banners {
    return [..._banners];
  }

  List<SingleBanner> _singleBanner = [];

  List<SingleBanner> get singleBanner => _singleBanner;

  var bannerTwoImageList = [];
  var featuredCategoryList = [];

  bool isCategoryInitial = true;

  bool isCarouselInitial = true;
  bool isBannerOneInitial = true;
  bool isFlashDealInitial = true;
  bool isBannerTwoInitial = true;
  bool isBannerFlashDeal = true;

  var featuredProductList = [];
  bool isFeaturedProductInitial = true;
  int? totalFeaturedProductData = 0;
  int featuredProductPage = 1;
  bool showFeaturedLoadingContainer = false;

  bool isTodayDeal = false;
  bool isFlashDeal = false;

  var allProductList = [];
  bool isAllProductInitial = true;
  int? totalAllProductData = 0;
  int allProductPage = 1;
  bool showAllLoadingContainer = false;
  int cartCount = 0;

  fetchAll() {
    fetchCarouselImages();
    fetchBannerOneImages();
    fetchBannerTwoImages();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchAllProducts();
    fetchTodayDealData();
    fetchFlashDealData();
    fetchBannerFlashDeal();
    fetchFlashDealBannerImages();
  }

  Future<void> fetchBannerFlashDeal() async {
    try {
      final banners = await SlidersRepository().fetchBanners();
      _banners = banners;
      notifyListeners();
    } catch (e) {
      print('Error loading banners: $e');
    }
  }

  fetchTodayDealData() async {
    var deal = await ProductRepository().getTodaysDealProducts();
    // print(deal.products!.length);
    // if (deal.success! && deal.products!.isNotEmpty) {
    //   isTodayDeal = true;
    //   notifyListeners();
    // }
    if (deal.success == true &&
        deal.products != null &&
        deal.products!.isNotEmpty) {
      isTodayDeal = true;
      notifyListeners();
    } else {
      isTodayDeal = false;
    }
  }

  fetchFlashDealData() async {
    var deal = await FlashDealRepository().getFlashDeals();

    if (deal.success == true &&
        deal.flashDeals != null &&
        deal.flashDeals!.isNotEmpty) {
      isFlashDeal = true;
      notifyListeners();
    } else {
      isFlashDeal = false;
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

  fetchFlashDealBannerImages() async {
    try {
      var flashDealBannerResponse =
          await SlidersRepository().getFlashDealBanner();
      flashDealBannerImageList.clear(); // Clear any previous data
      flashDealBannerImageList.addAll(flashDealBannerResponse.sliders!);
      isFlashDealInitial = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching flash deal banners: $e');
    }
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
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    featuredCategoryList.addAll(categoryResponse.categories!);
    isCategoryInitial = false;
    notifyListeners();
  }

  // fetchFeaturedProducts() async {
  //   var productResponse = await ProductRepository().getFeaturedProducts(
  //     page: featuredProductPage,
  //   );
  //   featuredProductPage++;
  //   featuredProductList.addAll(productResponse.products!);
  //   isFeaturedProductInitial = false;
  //   totalFeaturedProductData = productResponse.meta!.total;
  //   showFeaturedLoadingContainer = false;
  //   notifyListeners();
  // }

  fetchFeaturedProducts() async {
    try {
      var productResponse = await ProductRepository().getFeaturedProducts(
        page: featuredProductPage,
      );

      featuredProductPage++;

      if (productResponse.products != null) {
        featuredProductList.addAll(productResponse.products!);
      } else {}

      isFeaturedProductInitial = false;

      if (productResponse.meta != null) {
        totalFeaturedProductData = productResponse.meta!.total;
      } else {}

      showFeaturedLoadingContainer = false;
      notifyListeners();
    } catch (e) {}
  }

  // fetchAllProducts() async {
  //   var productResponse =
  //       await ProductRepository().getFilteredProducts(page: allProductPage);

  //   allProductList.addAll(productResponse.products!);
  //   isAllProductInitial = false;
  //   totalAllProductData = productResponse.meta!.total;
  //   showAllLoadingContainer = false;
  //   notifyListeners();
  // }
  fetchAllProducts() async {
    var productResponse =
        await ProductRepository().getFilteredProducts(page: allProductPage);

    if (productResponse.products != null) {
      allProductList.addAll(productResponse.products!);
    }
    isAllProductInitial = false;

    if (productResponse.meta != null) {
      totalAllProductData = productResponse.meta!.total;
    }

    showAllLoadingContainer = false;
    notifyListeners();
  }

  reset() {
    carouselImageList.clear();
    bannerOneImageList.clear();
    bannerTwoImageList.clear();
    featuredCategoryList.clear();

    isCarouselInitial = true;
    isBannerOneInitial = true;
    isBannerTwoInitial = true;
    isCategoryInitial = true;
    cartCount = 0;

    resetFeaturedProductList();
    resetAllProductList();
    flashDealBannerImageList.clear();
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
      //print("position: " + xcrollController.position.pixels.toString());
      //print("max: " + xcrollController.position.maxScrollExtent.toString());

      if (mainScrollController.position.pixels ==
          mainScrollController.position.maxScrollExtent) {
        allProductPage++;
        ToastComponent.showDialog(
          "More Products Loading...",
        );
        showAllLoadingContainer = true;
        fetchAllProducts();
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
