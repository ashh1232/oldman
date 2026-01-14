import 'dart:async';
import 'dart:convert';

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
  bool s = false;

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

  @override
  void onReady() {
    super.onReady();
    // fetchRoute();
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

        print(
          "📍 Location loaded: ${destinationLatLng.value.latitude}, ${destinationLatLng.value.longitude}",
        );
      }
    } catch (e) {
      print("⚠️ Error decoding location from storage: $e");
      // Default values in case of corruption
      destinationLatLng.value = const LatLng(0.0, 0.0);
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Save as a JSON string for easy decoding in CheckoutController
      Map<String, double> locationMap = {
        'lat': destinationLatLng.value.latitude,
        'lng': destinationLatLng.value.longitude,
      };
      await prefs.setString('location', jsonEncode(locationMap));
    } catch (e) {
      print("Storage Error: $e");
    }
  }

  ///
  // داخل الكلاس
  var mapStyle = 'streets'.obs; // streets, satellite, dark
  var showTraffic = false.obs;

  Future<void> _startTracking() async {
    // ... (كود التحقق من الصلاحيات السابق) ...
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // تحديث كل مترين لزيادة السلاسة
          ),
        ).listen((Position position) {
          LatLng newPos = LatLng(position.latitude, position.longitude);
          currentLatLng.value = newPos;
          currentHeading.value = position.heading; // تحديث زاوية الدوران
          if (!s) {
            s = true;
            destinationLatLng.value = currentLatLng.value;
          }
          // أضف هذا المتغير
          var isAutoCenter = true.obs;

          // داخل الـ listener الخاص بالـ positionStream
          if (isMapReady && isAutoCenter.value) {
            mapController.moveAndRotate(newPos, 17.0, position.heading);
          }

          // تحديث المسار
          // fetchRoute();
          // if (isMapReady) {
          //   try {
          //     mapController.moveAndRotate(
          //       newPos,
          //       17.0, // أو mapController.camera.zoom
          //       position.heading,
          //     );
          //   } catch (e) {
          //     // إذا فشل التحريك لأن الخريطة أغلقت، نقوم بإلغاء الاشتراك فوراً
          //     positionStream?.cancel();
          //   }
          // }
        });
  }

  // Future<void> fetchRoute() async {
  //   try {
  //     // 1. تحديد المعايير
  //     // final String profile = transportProfile.value;
  //     final double startLng = currentLatLng.value.longitude;
  //     final double startLat = currentLatLng.value.latitude;
  //     // final double endLng = destinationLatLng.value.longitude;
  //     // final double endLat = destinationLatLng.value.latitude;

  //     // 2. بناء الرابط باستخدام Uri لضمان عدم وجود أخطاء في الـ Host
  //     final Uri url = Uri.https(
  //       'router.project-osrm.org',
  //       '/route/v1/driving/$startLng,$startLat',
  //       {'overview': 'full', 'geometries': 'geojson'},
  //     );

  //     print("🔗 جاري الاتصال بالرابط: $url");

  //     final response = await GetConnect().get(url.toString());

  //     if (response.isOk &&
  //         response.body['routes'] != null &&
  //         response.body['routes'].isNotEmpty) {
  //       // الوصول للمسار الأول (تأكد من وجود [0])
  //       var routeData = response.body['routes'][0];
  //       var geometry = routeData['geometry']['coordinates'];

  //       List<LatLng> points = geometry.map<LatLng>((c) {
  //         // تحويل من [Longitude, Latitude] إلى LatLng(Latitude, Longitude)
  //         return LatLng(c[1].toDouble(), c[0].toDouble());
  //       }).toList();

  //       routePoints.assignAll(points);
  //       // distanceRemaining.value = (routeData['distance'] as num).toDouble();
  //     }
  //   } catch (e) {
  //     print("⚠️ خطأ تقني: $e");
  //   }
  // }

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
