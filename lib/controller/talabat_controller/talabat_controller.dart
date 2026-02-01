import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/bunner_model.dart';
import 'package:maneger/model/cat_model.dart';
import 'package:maneger/model/product_model.dart';
import 'dart:async';

class TalabatController extends GetxController {
  // Observables
  final Rx<StatusRequest> statusRequest = StatusRequest.loading.obs;
  final RxList<Bunner> banners = <Bunner>[].obs;
  final RxList<Category> catList = <Category>[].obs;
  final RxList<Product> productList = <Product>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isBanLoading = false.obs;
  final RxBool isCatLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxBool isScrolled = false.obs;

  final Crud _crud = Crud();
  int page = 1;
  Timer? _bannerTimer;

  late final PageController pageController;
  late final ScrollController scrollController;

  @override
  void onInit() {
    pageController = PageController();
    scrollController = ScrollController();
    initData();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent - 300)) {
        if (!isLoading.value && hasMore.value) {
          getData();
        }
      }
    });
    super.onInit();
  }

  Future<void> initData() async {
    statusRequest.value = StatusRequest.loading;
    try {
      // Parallel execution for better startup time
      await Future.wait([getBanners(), getCatData(), getData()]);

      if (productList.isEmpty && catList.isEmpty) {
        statusRequest.value = StatusRequest.failure;
      } else {
        statusRequest.value = StatusRequest.success;
      }
      _startBannerAutoPlay();
    } catch (e) {
      statusRequest.value = StatusRequest.failure;
    }
  }

  Future<void> getBanners() async {
    if (isBanLoading.value) return;
    isBanLoading.value = true;
    try {
      print(ApiConstants.banners);
      var response = await _crud.postData(ApiConstants.banners, {});
      response.fold((status) => _handleError(status, "فشل تحميل الإعلانات"), (
        res,
      ) {
        if (res['status'] == 'success') {
          final List decod = res['data'];
          banners.assignAll(decod.map((ban) => Bunner.fromJson(ban)).toList());
        }
      });
    } catch (e) {
      _handleError(StatusRequest.serverfailure, "خطأ غير متوقع");
    } finally {
      isBanLoading.value = false;
    }
  }

  Future<void> getCatData() async {
    if (isCatLoading.value) return;
    isCatLoading.value = true;
    try {
      var response = await _crud.postData(ApiConstants.categories, {});
      response.fold((status) => _handleError(status, "فشل تحميل الأقسام"), (
        res,
      ) {
        if (res['status'] == "success") {
          final List decod = res['data'];
          catList.assignAll(decod.map((e) => Category.fromJson(e)).toList());
        }
      });
    } catch (e) {
      _handleError(StatusRequest.serverfailure, "خطأ في الاتصال");
    } finally {
      isCatLoading.value = false;
    }
  }

  Future<void> getData() async {
    if (isLoading.value || !hasMore.value) return;
    isLoading.value = true;
    try {
      var response = await _crud.getData("${ApiConstants.products}?page=$page");
      response.fold((status) => _handleError(status, "فشل تحميل المنتجات"), (
        res,
      ) {
        if (res['status'] == 'success') {
          List newDataList = res['data'];
          if (newDataList.isEmpty) {
            hasMore.value = false;
          } else {
            productList.addAll(
              newDataList.map((j) => Product.fromJson(j)).toList(),
            );
            page++;
            if (res['metadata'] != null) {
              if (res['metadata']['current_page'] >=
                  res['metadata']['total_pages']) {
                hasMore.value = false;
              }
            }
          }
        }
      });
    } catch (e) {
      if (page == 1) _showErrorSnackbar("تحقق من الاتصال بالإنترنت");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(StatusRequest status, String message) {
    if (status == StatusRequest.offline) {
      _showErrorSnackbar("أنت غير متصل بالإنترنت");
    } else {
      _showErrorSnackbar(message);
    }
  }

  void _showErrorSnackbar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isSnackbarOpen) {
        Get.rawSnackbar(
          message: message,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.black87,
        );
      }
    });
  }

  void _startBannerAutoPlay() {
    _bannerTimer?.cancel();
    if (banners.length <= 1) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients &&
          !pageController.position.isScrollingNotifier.value) {
        int nextPage = (currentBannerIndex.value + 1) % banners.length;
        currentBannerIndex.value = nextPage;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void setBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  void toggleScroll(bool scrolled) {
    if (isScrolled.value != scrolled) {
      isScrolled.value = scrolled;
    }
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    pageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
