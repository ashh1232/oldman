import 'package:maneger/class/statusrequest.dart';

StatusRequest handlingData(Object? response) {
  // 1. التأكد أولاً ما إذا كان الرد عبارة عن خطأ حالة (مثل فشل الاتصال)
  if (response is StatusRequest) {
    return response;
  }
  // 2. إذا كان الرد خريطة (Map)، نتحقق من محتواها
  else if (response is Map) {
    // التحقق مما إذا كان السيرفر قد أعاد قائمة فارغة أو ردًا فارغاً
    if (response.isEmpty) {
      return StatusRequest.none; // أو failure حسب تصميمك
    }
    return StatusRequest.success;
  }
  // 3. حالة احتياطية لأي نوع بيانات آخر غير متوقع
  else {
    return StatusRequest.serverfailure;
  }
}
