import '../controller/talabat_controller/checkout_controller.dart';

class LocationService {
  static Future<void> syncCoordinates(CheckoutController controller) async {
    // Since hasValidLocation doesn't exist, we'll check if map coordinates are valid
    bool hasValidLocation = _checkValidMapLocation(controller);

    if (hasValidLocation) {
      // Update coordinates from map controller
      controller.selectedLat.value =
          controller.mapController.destinationLatLng.value.latitude;
      controller.selectedLong.value =
          controller.mapController.destinationLatLng.value.longitude;
    } else {
      await _loadFromStorage(controller);
      if (!_hasValidCoordinates(controller)) {
        await _reverseGeocodeAddress(controller); // Convert address to coords
      }
    }
  }

  static bool _checkValidMapLocation(CheckoutController controller) {
    // Check if the map has valid coordinates (non-zero)
    var latLng = controller.mapController.destinationLatLng.value;
    return latLng.latitude != 0.0 && latLng.longitude != 0.0;
  }

  static bool _hasValidCoordinates(CheckoutController controller) {
    // Replicating the validation logic from the controller
    return controller.selectedLat.value != 0.0 &&
        controller.selectedLong.value != 0.0 &&
        controller.selectedLat.value.abs() <= 90 &&
        controller.selectedLong.value.abs() <= 180;
  }

  static Future<void> _loadFromStorage(CheckoutController controller) async {
    controller.ismap.value = true;
    try {
      // You'll need to import shared_preferences here
      // import 'package:shared_preferences/shared_preferences.dart';
      // import 'dart:convert';

      // For this to work, you'd need to pass these imports to this file
      // Or create a wrapper method in the controller
    } catch (e) {
      print("⚠️ Error decoding location from storage: $e");
    }
    controller.ismap.value = false;
  }

  static Future<void> _reverseGeocodeAddress(
    CheckoutController controller,
  ) async {
    // This function needs to be implemented based on your geocoding service
    // For now, this is a placeholder
  }
}
