class ScreenshotItem {
  final String imageUrl;
  final List<String> tags;

  ScreenshotItem({required this.imageUrl, required this.tags});

  factory ScreenshotItem.fromJson(Map<String, dynamic> json) {
    return ScreenshotItem(
      imageUrl: json['image_url'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
