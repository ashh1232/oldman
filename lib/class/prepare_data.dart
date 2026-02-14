Map prepareData(Map data) {
  Map cleanedData = Map.from(data);
  cleanedData.forEach((key, value) {
    if (value is String) {
      cleanedData[key] = value
          .replaceAll('٠', '0')
          .replaceAll('١', '1')
          .replaceAll('٢', '2')
          .replaceAll('٣', '3')
          .replaceAll('٤', '4')
          .replaceAll('٥', '5')
          .replaceAll('٦', '6')
          .replaceAll('٧', '7')
          .replaceAll('٨', '8')
          .replaceAll('٩', '9');
    }
  });
  return cleanedData;
}
