String getImageUrl(String category, String type) {
  if (category.startsWith('http')) return category;

  // تنظيف المسارات لضمان عدم تكرار الـ '/' أو نسيانه
  final cleanType = type.endsWith('/') ? type : '$type/';
  final cleanCategory = category.startsWith('/')
      ? category.substring(1)
      : category;

  return '$cleanType$cleanCategory';
}
