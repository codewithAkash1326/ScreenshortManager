class ScreenshotItem {
  final String tag;
  final String preview;

  ScreenshotItem({required this.tag, required this.preview});

  factory ScreenshotItem.fromJson(Map<String, dynamic> json) =>
      ScreenshotItem(tag: json['tag'] ?? '', preview: json['preview'] ?? '');
}
