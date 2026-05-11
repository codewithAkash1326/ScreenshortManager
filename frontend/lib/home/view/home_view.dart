import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/home/controller/home_controller.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Colors.black;
    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Capturely', style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        final idx = controller.selectedIndex.value;
        if (idx == 1) {
          return _AboutView(onLogout: controller.logout);
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchShots(),
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF05090C), Colors.black],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.SEARCH),
                      child: AbsorbPointer(child: _SearchBar()),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.shots.isEmpty) {
                          return ListView(
                            children: const [
                              SizedBox(height: 200),
                              Center(
                                child: Text(
                                  'No screenshots yet',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          );
                        }
                        return GridView.builder(
                          itemCount: controller.shots.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.82,
                              ),
                          itemBuilder: (context, index) {
                            final shot = controller.shots[index];
                            return _ShotCard(
                              tags: shot.tags,
                              preview: shot.imageUrl,
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 6),
        child: FloatingActionButton(
          onPressed: () => _showUploadBottomSheet(context),
          backgroundColor: const Color(0xFF00D1B2),
          foregroundColor: Colors.black,
          shape: const CircleBorder(),
          elevation: 0,
          highlightElevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() {
        final idx = controller.selectedIndex.value;
        return BottomAppBar(
          color: Colors.black,
          surfaceTintColor: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            bottom: true,
            child: SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BottomItem(
                            icon: idx == 0 ? Icons.home : Icons.home_outlined,
                            label: 'Home',
                            selected: idx == 0,
                            onTap: () => controller.changeIndex(0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 74), // notch / FAB space
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BottomItem(
                            icon: idx == 1 ? Icons.info : Icons.info_outline,
                            label: 'About',
                            selected: idx == 1,
                            onTap: () => controller.changeIndex(1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showUploadBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Obx(() {
        final uploading = controller.isUploading.value;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF111111),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// TOP HANDLE
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 28),

                /// TITLE
                const Text(
                  "Upload Screenshot",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Choose an image from your gallery",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),

                const SizedBox(height: 32),

                /// PICK IMAGE CARD
                GestureDetector(
                  onTap: uploading
                      ? null
                      : () => controller.pickAndUploadImage(),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: uploading ? 0.55 : 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00D1B2), Color(0xFF00A8E8)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00D1B2).withOpacity(0.25),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.photo_library_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),

                          SizedBox(width: 18),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pick from Gallery",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "Only one image can be uploaded",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (uploading) ...[
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF00D1B2),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Uploading...",
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () => Get.toNamed(AppRoutes.SEARCH),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search screenshots, text or tags',
        hintStyle: const TextStyle(color: Colors.white60),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00D1B2)),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF00D1B2) : Colors.white70;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShotCard extends StatelessWidget {
  const _ShotCard({required this.tags, required this.preview});

  final List<String> tags;
  final String preview;

  @override
  Widget build(BuildContext context) {
    final visibleTags = tags.take(2).toList();
    final remaining = tags.length - visibleTags.length;

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.IMAGE_VIEWER,
        arguments: {'imageUrl': preview, 'tags': tags},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0B0F12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              AspectRatio(
                aspectRatio: 1.18,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      preview,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.white.withOpacity(0.06),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.white.withOpacity(0.04),
                          child: const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                    ),
                    // bottom fade so tags feel integrated
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// TAG ROW
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                child: SizedBox(
                  height: 26,
                  child: Row(
                    children: [
                      ...visibleTags.map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _tagChip(tag),
                        ),
                      ),
                      if (remaining > 0) _tagChip("+$remaining"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tagChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "#$text",
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}

class _AboutView extends StatelessWidget {
  const _AboutView({required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Screenshot is a simple app to upload screenshots, organize them by tags, and quickly search later. The backend stores your images and returns previews + tags for a clean grid view.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                height: 1.35,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Built with Flutter (GetX) + FastAPI. Uploads go to Cloudinary and metadata is stored in Postgres.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                height: 1.35,
                fontSize: 14,
              ),
            ),
            SizedBox(height: height * 0.4),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D1B2),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Log out",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
