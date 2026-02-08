import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/talabat_controller/talabat_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/screen/talabat/product_detail_view.dart';
import 'package:maneger/widget/loading_card.dart';
import 'package:maneger/widget/product_card.dart';
import '../../widget/talabat/home_cat_items.dart';
import '../../widget/talabat/home_page_widgets.dart';
import '../../widget/talabat/talabat_drawer.dart';

class TalabatHomeScreen extends StatelessWidget {
  TalabatHomeScreen({super.key});
  final TalabatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const TalabatDrawer(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0 &&
              notification is ScrollUpdateNotification) {
            bool isOverThreshold = notification.metrics.pixels > 50;
            if (isOverThreshold != controller.isScrolled.value) {
              controller.toggleScroll(isOverThreshold);
            }
          }
          return false;
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          cacheExtent: 500,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => controller.refreshHome(),
            ),
            SliverAppBar(
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              pinned: true,
              stretch: true,
              expandedHeight: 220,
              elevation: 0,
              title: Semantics(
                label: 'شريط البحث',
                child: SizedBox(
                  height: 35,
                  child: TalabatSearchBar(controller: controller),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: TalabatCarouselBanner(controller: controller),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(500),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                height: 50,
                child: const TalabatPromoBanner(),
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isCatError.value) {
                  return SizedBox(
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text('حدث خطأ في تحميل الفئات'),
                          TextButton(
                            onPressed: () => controller.loadCategories(),
                            child: const Text('إعادة تحميل'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 180,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: controller.isCatLoading.value
                        ? 10
                        : controller.catList.length,
                    itemBuilder: (context, index) {
                      if (controller.isCatLoading.value) {
                        return const LoadingCard(height: 20);
                      }
                      final cat = controller.catList[index];
                      return HomeCatItems(
                        img: cat.image.startsWith('http')
                            ? cat.image
                            : ApiConstants.categoriesImages + cat.image,
                        title: cat.title,
                        id: cat.id,
                      );
                    },
                  ),
                );
              }),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Main content with error handling
            Obx(() {
              if (controller.hasError.value && controller.productList.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text('حدث خطأ أثناء تحميل المنتجات'),
                        ElevatedButton(
                          onPressed: () => controller.initData(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.productList.isEmpty &&
                  controller.isLoading.value) {
                // Show skeleton loading when no products yet
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const LoadingCard(height: 150),
                    childCount: 8, // Show skeleton for expected items
                  ),
                );
              }

              int crossAxisCount = _getCrossAxisCount(context);

              return SliverPadding(
                padding: const EdgeInsets.all(5),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 5,
                  childCount: _getChildCount(),
                  itemBuilder: (context, index) {
                    return _buildListItem(index);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > 600 ? 4 : 2;
  }

  int _getChildCount() {
    int baseCount = controller.productList.length;

    if (controller.isLoading.value &&
        controller.hasMore.value &&
        controller.productList.isNotEmpty) {
      return baseCount + 1; // Add loading indicator
    }
    return baseCount;
  }

  Widget _buildListItem(int index) {
    // Check if this is the loading indicator
    if (index >= controller.productList.length) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(3.0),
          child: LoadingCard(height: 180),
        ),
      );
    }

    final product = controller.productList[index];
    return _buildProductItem(product, index);
  }

  Widget _buildProductItem(dynamic product, int index) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      openColor: Colors.white,
      closedColor: Colors.transparent,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      openBuilder: (context, action) =>
          ProductDetailView(manualProduct: product),
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: () => openContainer(),
          child: ProductCard(
            index: index,
            img: product.image.startsWith('http')
                ? product.image
                : "${ApiConstants.productsImages}/${product.image}",
            title: product.title,
            price: double.tryParse(product.price.toString()) ?? 0.0,
            oldPrice: double.tryParse(product.originalPrice.toString()) ?? 0.0,
            hash: product.blurHash.isEmpty
                ? r"UgIE@UoL~qtR%2ofS4WB%MofWCbGxuj[V@fQ"
                : product.blurHash,
          ),
        );
      },
    );
  }
}
