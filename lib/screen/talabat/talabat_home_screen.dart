import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/talabat/talabat_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';
import 'package:maneger/screen/talabat/product_detail_view.dart';
import 'package:maneger/service/theme_service.dart';
import 'package:maneger/widget/loading_card.dart';
import 'package:maneger/widget/product_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class TalabatHomeScreen extends StatelessWidget {
  TalabatHomeScreen({super.key});
  final TalabatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // 1. نتحقق أن التمرير رأسي فقط (العمق 0 يعني السكرول الأساسي وليس الداخلي)
          if (notification.depth == 0 &&
              notification is ScrollUpdateNotification) {
            // 2. نتحقق من المسافة
            bool isOverThreshold = notification.metrics.pixels > 50;

            // 3. التحديث فقط إذا تغيرت الحالة فعلياً
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
              onRefresh: () async {
                controller.page = 1; // Reset page to 1
                controller.hasMore(true); // Allow loading again
                controller.productList.clear(); // Clear old data
                await controller.initData();
              },
            ),
            SliverAppBar(
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              pinned: true,
              stretch: true, // يمنع الفراغات البيضاء عند السحب لأسفل

              floating: false,
              expandedHeight: 220,
              elevation: 0,
              title: SizedBox(height: 35, child: _buildSearchBar(controller)),
              actions: [],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildCarouselBanner(controller),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10), // المسافة المطلوبة
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(500),
                    ), // حواف دائرية تجعل الشبكة تبدو وكأنها تدخل تحت الـ AppBar
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                height: 50,
                // color: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
                child: _buildCobon(),
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 180, // الارتفاع الكلي للشبكة
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    // إضافة التنسيق لجعل المسافات أفضل
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // سيظهر صفين فوق بعضهما البعض
                      mainAxisSpacing: 0, // المسافة الأفقية بين العناصر
                      crossAxisSpacing: 5, // المسافة الرأسية بين الصفين
                      childAspectRatio:
                          0.8, // هام جداً: يتحكم في عرض العنصر (جرب 0.7 إلى 1.0)
                    ),
                    itemCount: controller.isCatLoading.value
                        ? 10 // عدد عناصر التحميل
                        : controller.catList.length,
                    itemBuilder: (context, index) {
                      if (controller.isCatLoading.value) {
                        return const LoadingCard(height: 20);
                      }
                      return HomeCatItems(
                        img: controller.catList[index].image.startsWith('https')
                            ? controller.catList[index].image
                            : AppLink.catsimages +
                                  controller.catList[index].image,
                        title: controller.catList[index].title,
                        controller: controller,
                        id: controller.catList[index].id,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            Obx(() {
              double screenWidth = MediaQuery.of(context).size.width;

              // 2. نحدد عدد الأعمدة بناءً على العرض (عتبة الـ 600 بكسل هي المعيار للأجهزة اللوحية والمطوية)
              int crossAxisCount = screenWidth > 600 ? 4 : 2;

              return SliverPadding(
                padding: EdgeInsetsGeometry.all(5),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount:
                      crossAxisCount, //// how to use 4 in samsong flod and 2 in normal phons
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 5,

                  childCount:
                      controller.isLoading.value &&
                          controller.productList.isEmpty
                      ? 9
                      : controller.productList.length +
                            (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.productList.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: LoadingCard(height: 180),
                        ),
                      );
                    }
                    if (controller.productList.isEmpty &&
                        controller.isLoading.value) {
                      return const LoadingCard(height: 150);
                    } else {
                      final product = controller.productList[index];
                      return OpenContainer(
                        transitionDuration: const Duration(milliseconds: 500),
                        // لون الخلفية أثناء الانتقال
                        openColor: Colors.white,
                        closedColor: Colors.transparent,
                        closedElevation: 0,
                        // شكل الكارت قبل الفتح
                        closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        // الصفحة التي سيتم فتحها
                        openBuilder: (context, action) {
                          return ProductDetailView(manualProduct: product);
                          // ملاحظة: GetX سيتعامل مع Arguments تلقائياً لأننا سنمررها في closedBuilder
                        },
                        // الكارت الذي يراه المستخدم في القائمة
                        closedBuilder: (context, openContainer) {
                          return InkWell(
                            onTap: () {
                              // نمرر البيانات يدوياً قبل الفتح لضمان وصولها لـ ProductDetailView
                              // Get.arguments = product;
                              openContainer(); // تشغيل أنميشن الفتح
                            },
                            child: ProductCard(
                              index: index,
                              img: product.image.startsWith('http')
                                  ? product.image
                                  : "${AppLink.productsimages}/${product.image}",
                              title: product.title,
                              price:
                                  double.tryParse(product.price.toString()) ??
                                  0.0,
                              oldPrice:
                                  double.tryParse(
                                    product.originalPrice.toString(),
                                  ) ??
                                  0.0,
                              hash: product.blurHash.isEmpty
                                  ? r"UgIE@UoL~qtR%2ofS4WB%MofWCbGxuj[V@fQ"
                                  : product.blurHash, //Expected an identifier
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

Widget _buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.amber),
          child: Text(
            'Navigation',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('تعديل banner'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.editBanScreen);
          },
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('تعديل المنتجات'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.addscreen);
          },
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('تعديل الكاتيجوري'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.editCatScreen);
          },
        ),
        ListTile(
          leading: Icon(Icons.delivery_dining),
          title: Text('delivery'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.deliHome);
          },
        ),
        ListTile(
          leading: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          title: Text(Get.isDarkMode ? "الوضع النهاري" : "الوضع الليلي"),
          onTap: () {
            ThemeService().switchTheme();
          },
        ),

        ListTile(
          leading: Icon(Icons.person),
          title: Text('البروفايل'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.profile);
          },
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('للتواصل'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.mail);
          },
        ),
      ],
    ),
  );
}

Widget _buildCarouselBanner(TalabatController controller) {
  return Obx(() {
    if (controller.isBanLoading.value || controller.banners.isEmpty) {
      return const LoadingCard(
        height: 220,
      ); // تأكد من مطابقة ارتفاع expandedHeight
    }

    return Stack(
      children: [
        PageView.builder(
          physics:
              const ClampingScrollPhysics(), // تمنع الارتداد الذي قد يرسل إشارات تمرير خاطئة
          allowImplicitScrolling: true,
          controller: controller.pageController,
          itemCount: controller.banners.length,
          onPageChanged: (index) => controller.currentBannerIndex.value = index,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              key: ValueKey(
                controller.banners[index].id,
              ), // الأفضل استخدام الـ ID
              imageUrl: controller.banners[index].image.startsWith('http')
                  ? controller.banners[index].image
                  : AppLink.bannersimages + controller.banners[index].image,
              fit: BoxFit.cover, // يضمن عدم تأثر أبعاد الـ AppBar بحجم الصورة
              // ... الباقي كما هو
            );
          },
        ),
        // يمكنك هنا إضافة Gradient خفيف في الأسفل ليظهر الـ AppBar بوضوح أكبر
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black26,
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: [0.0, 0.3, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  });
}

Widget _buildCobon() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 3),
    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 1),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 247, 244, 221),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'عروض حصرية ',

                        style: TextStyle(
                          color: const Color.fromARGB(255, 66, 16, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Icon(
                        Icons.flash_on,
                        color: const Color.fromARGB(255, 66, 16, 0),
                        size: 15,
                      ),
                    ],
                  ),
                  Text(
                    'شاهد العروض الحصرية الان',
                    style: TextStyle(color: Colors.grey, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 30,
          width: 0.5,
          color: const Color.fromARGB(255, 128, 31, 1),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'توصيل مجاني',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 66, 16, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.local_shipping,
                    color: const Color.fromARGB(255, 66, 16, 0),
                    size: 15,
                  ),
                ],
              ),
              Text(
                'اشترى ب 114.00\$ اكثر لتحصل علي',
                style: TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSearchBar(TalabatController controller) {
  return Row(
    children: [
      Expanded(
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            padding: EdgeInsets.symmetric(
              horizontal: controller.isScrolled.value ? 20 : 0,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.isScrolled.value
                  ? Container(
                      height: 36, // نفس ارتفاع الـ Container الآخر
                      alignment: Alignment.centerRight, // لضمان ثبات النص
                      child: Text(
                        'طلبات',
                        key: const ValueKey(1),
                        style: GoogleFonts.lalezar(
                          fontSize: 28,
                        ), // تقليل الخط قليلاً ليتناسب مع الارتفاع
                      ),
                    )
                  : Container(
                      height: 36,
                      key: const ValueKey(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.08),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.camera_alt_outlined, size: 22),
                          SizedBox(width: 8),
                          Expanded(
                            child:
                                //  _buildSearchBbar(controller),
                                Text(
                                  'ملابس رجالي و ستاتي',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,

                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            height: 30,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.search,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
      Obx(
        () => InkWell(
          onTap: () => Get.toNamed(AppRoutes.favorite),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.favorite_border,
              size: 22,
              color: controller.isScrolled.value ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
      Obx(
        () => IconButton(
          onPressed: () => Get.toNamed(AppRoutes.cartPage),
          icon: Icon(
            Icons.shopping_cart_checkout_sharp,
            size: 24,
            color: controller.isScrolled.value
                ? Colors.black
                : Colors.white, // تغيير اللون لجذب الانتباه
          ),
        ),
      ),
    ],
  );
}

Widget _buildCategoryItem(String title, {bool isSelected = false}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        if (isSelected)
          Container(
            margin: EdgeInsets.only(top: 4),
            height: 2,
            width: 20,
            color: Colors.white,
          ),
      ],
    ),
  );
}

class HomeCatItems extends StatelessWidget {
  final String img;
  final String title;
  final String id;
  final dynamic controller;

  const HomeCatItems({
    super.key,
    required this.img,
    required this.title,
    required this.controller,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // منطق الفلترة حسب القسم هنا
        Get.toNamed(AppRoutes.category, arguments: id);
      },
      child: Column(
        children: [
          // دائرة الصورة
          Expanded(
            child: Container(
              width: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(19),
                child: CachedNetworkImage(
                  key: ValueKey(img), // أضف هذا السطر

                  imageUrl: img,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.category_outlined),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // اسم القسم
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
// Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Row(
//           children: [
//             Icon(Icons.menu, color: Colors.white, size: 30),
//             SizedBox(width: 15),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     _buildCategoryItem("kids"),
//                     _buildCategoryItem("shoes"),
//                     _buildCategoryItem("electronics"),
//                     _buildCategoryItem("woman"),
//                     _buildCategoryItem("men"),
//                     _buildCategoryItem("men"),
//                     _buildCategoryItem("all", isSelected: true),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),