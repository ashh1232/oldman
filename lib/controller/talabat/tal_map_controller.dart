import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:maneger/controller/talabat/checkout_controller.dart';
import 'package:maneger/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TalMapController extends GetxController {
  final MapController mapController = MapController();

  Rx<LatLng> currentLatLng = const LatLng(
    31.417272,
    34.970499,
  ).obs; // مثال: الرياض
  // var destinationLatLng = const LatLng(31.410972, 34.970001).obs;
  Rx<LatLng> destinationLatLng = const LatLng(31.410972, 34.970001).obs;
  var routePoints = <LatLng>[].obs;
  var currentHeading = 0.0.obs; // إضافة متغير الاتجاه
  bool isMapReady = false;
  bool isFirstLocationFix = false;
  var isAutoCenter = true.obs;

  ///
  StreamSubscription<Position>? positionStream;

  @override
  void onInit() {
    super.onInit();
    _startTracking();
    if (Get.arguments != null) {
      destinationLatLng.value = LatLng(
        Get.arguments['lat'],
        Get.arguments['lng'],
      );
    } else {
      // Fallback: load from storage if arguments are missing
      _loadFromStorage();
    }
  }

  var currentTileUrl = 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}'.obs;

  void changeMapStyle(String style) {
    switch (style) {
      case 'satellite':
        // رابط القمر الصناعي مع المسار الكامل
        currentTileUrl.value =
            'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}';
        break;

      default:
        currentTileUrl.value =
            'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
    }
  }

  void onLongPress(LatLng point) {
    destinationLatLng.value = point;
    // fetchRoute();
  }

  void onMapReady() {
    isMapReady = true;
  }

  ///////////
  // void newDestinations() {
  //   _saveToStorage();
  //   Get.toNamed(
  //     AppRoutes.checkout,
  //     arguments: {
  //       'lat': destinationLatLng.value.latitude,
  //       'lng': destinationLatLng.value.longitude,
  //     },
  //   );
  // }

  void newDestinations() async {
    await _saveToStorage();

    // Force delete the existing controller if it exists
    if (Get.isRegistered<CheckoutController>()) {
      Get.delete<CheckoutController>();
    }

    Get.toNamed(AppRoutes.checkout);
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString('location');

      if (raw == null || raw.isEmpty) return;

      // 1. Decode the JSON string back into a Map
      final Map<String, dynamic> locationData = jsonDecode(raw);

      // 2. Assign values to your Rx variables
      if (locationData.containsKey('lat') && locationData.containsKey('lng')) {
        destinationLatLng.value = LatLng(
          locationData['lat'],
          locationData['lng'],
        );

        debugPrint(
          "📍 Location loaded: ${destinationLatLng.value.latitude}, ${destinationLatLng.value.longitude}",
        );
      }
    } catch (e) {
      debugPrint("⚠️ Error decoding location from storage: $e");
      // Default values in case of corruption
      destinationLatLng.value = const LatLng(0.0, 0.0);
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, double> locationMap = {
        'lat': destinationLatLng.value.latitude,
        'lng': destinationLatLng.value.longitude,
      };
      await prefs.setString('location', jsonEncode(locationMap));
    } catch (e) {
      debugPrint("Storage Error: $e");
    }
  }

  ///
  // داخل الكلاس
  var mapStyle = 'streets'.obs; // streets, satellite, dark
  var showTraffic = false.obs;

  Future<void> _startTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // تحديث كل مترين لزيادة السلاسة
          ),
        ).listen((Position position) {
          LatLng newPos = LatLng(position.latitude, position.longitude);
          currentLatLng.value = newPos;
          currentHeading.value = position.heading;

          if (!isFirstLocationFix) {
            isFirstLocationFix = true;
            destinationLatLng.value = currentLatLng.value;
          }

          if (isMapReady && isAutoCenter.value) {
            mapController.moveAndRotate(newPos, 17.0, position.heading);
          }
        });
  }

  @override
  void onClose() {
    // 1. إلغاء الاشتراك يمنع Geolocator من إرسال بيانات جديدة للمحرك
    positionStream?.cancel();
    positionStream = null;

    // 2. التخلص من متحكم الخريطة
    mapController.dispose();

    super.onClose();
  }
}
