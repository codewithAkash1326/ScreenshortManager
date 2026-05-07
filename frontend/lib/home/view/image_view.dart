import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String imageUrl = args['imageUrl'];
    final List tags = args['tags'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🔍 Zoomable Image
          Center(
            child: Hero(
              tag: imageUrl,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.network(imageUrl),
              ),
            ),
          ),

          /// 🔙 Back Button (GetX)
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          /// 📌 Bottom Tags Panel
          DraggableScrollableSheet(
            initialChildSize: 0.15,
            minChildSize: 0.1,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags.map<Widget>((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.white10,
                        labelStyle: TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
