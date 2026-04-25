import 'package:frontend/home/models/screenshot_item.dart';

class ScreenshotResponse {
  final List<ScreenshotItem> items;

  ScreenshotResponse({required this.items});

  factory ScreenshotResponse.fromJson(Map<String, dynamic> json) {
    final List dataList = json['data'] ?? [];

    return ScreenshotResponse(
      items: dataList.map((e) => ScreenshotItem.fromJson(e)).toList(),
    );
  }
}
