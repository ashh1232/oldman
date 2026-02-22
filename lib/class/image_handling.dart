String getImageUrl(String imageName, String baseUrl) {
  if (imageName.isEmpty) return "";
  if (imageName.startsWith('http')) return imageName;

  // تنظيف الـ Base URL من أي شرطة في النهاية
  final cleanBase = baseUrl.endsWith('/')
      ? baseUrl.substring(0, baseUrl.length - 1)
      : baseUrl;

  // تنظيف اسم الصورة من أي شرطة في البداية
  final cleanPath = imageName.startsWith('/')
      ? imageName.substring(1)
      : imageName;

  return '$cleanBase/$cleanPath';
}
