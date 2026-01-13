class Images {
  final String id;
  final String image;

  Images({required this.image, required this.id});

  factory Images.fromJsom(Map<String, dynamic> json) {
    return Images(
      id: (json['id'] ?? json['product_id'] ?? "1").toString(),
      image:
          (json['image'] ??
                  json['product_image'] ??
                  "https://iraq.talabat.com/assets/images/header_image-EN.png")
              .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image};
  }
}
