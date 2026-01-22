import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/talabat/talabat_controller.dart';
import '../../linkapi.dart';
import '../../routes.dart';
import '../loading_card.dart';

class TalabatSearchBar extends StatelessWidget {
  final TalabatController controller;
  const TalabatSearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                        height: 36,
                        alignment: Alignment.centerRight,
                        child: Text(
                          'طلبات',
                          key: const ValueKey(1),
                          style: GoogleFonts.lalezar(fontSize: 28),
                        ),
                      )
                    : _buildFullSearchBar(),
              ),
            ),
          ),
        ),
        _buildIconAction(
          icon: Icons.favorite_border,
          onTap: () => Get.toNamed(AppRoutes.favorite),
          controller: controller,
        ),
        _buildIconAction(
          icon: Icons.shopping_cart_checkout_sharp,
          onTap: () => Get.toNamed(AppRoutes.cartPage),
          controller: controller,
        ),
      ],
    );
  }

  Widget _buildFullSearchBar() {
    return Container(
      height: 36,
      key: const ValueKey(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.camera_alt_outlined, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'ملابس رجالي و ستاتي',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            height: 30,
            margin: const EdgeInsets.all(5),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.search, size: 22, color: Colors.white),
            ),
          ),
          Container(width: 1, height: 20, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _buildIconAction({
    required IconData icon,
    required VoidCallback onTap,
    required TalabatController controller,
  }) {
    return Obx(
      () => IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 24,
          color: controller.isScrolled.value ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}

class TalabatCarouselBanner extends StatelessWidget {
  final TalabatController controller;
  const TalabatCarouselBanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isBanLoading.value || controller.banners.isEmpty) {
        return const LoadingCard(height: 220);
      }

      return Stack(
        children: [
          PageView.builder(
            physics: const ClampingScrollPhysics(),
            allowImplicitScrolling: true,
            controller: controller.pageController,
            itemCount: controller.banners.length,
            onPageChanged: (index) =>
                controller.currentBannerIndex.value = index,
            itemBuilder: (context, index) {
              final banner = controller.banners[index];
              return CachedNetworkImage(
                key: ValueKey(banner.id),
                imageUrl: banner.image.startsWith('http')
                    ? banner.image
                    : AppLink.bannersimages + banner.image,
                fit: BoxFit.cover,
              );
            },
          ),
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
}

class TalabatPromoBanner extends StatelessWidget {
  const TalabatPromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 244, 221),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPromoItem(
            title: 'عروض حصرية',
            subtitle: 'شاهد العروض الحصرية الان',
            icon: Icons.flash_on,
          ),
          Container(
            height: 30,
            width: 0.5,
            color: const Color.fromARGB(255, 128, 31, 1),
          ),
          _buildPromoItem(
            title: 'توصيل مجاني',
            subtitle: 'اشترى ب 114.00\$ اكثر لتحصل علي',
            icon: Icons.local_shipping,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 66, 16, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, color: const Color.fromARGB(255, 66, 16, 0), size: 15),
            ],
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
