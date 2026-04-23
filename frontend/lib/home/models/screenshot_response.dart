import 'package:frontend/home/models/screenshot_item.dart';

class ScreenshotResponse {
  final List<ScreenshotItem> items;

  ScreenshotResponse({required this.items});

  factory ScreenshotResponse.fromJson(List<dynamic> jsonList) {
    return ScreenshotResponse(
      items: jsonList.map((e) => ScreenshotItem.fromJson(e)).toList(),
    );
  }
}
