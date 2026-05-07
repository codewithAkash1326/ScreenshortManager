import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/home/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Colors.black;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Screenshots', style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchShots(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.shots.isEmpty) {
                      return ListView(
                        children: [
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
                            childAspectRatio: 0.85,
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
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 64,
          backgroundColor: Colors.black,

          elevation: 0,
          indicatorColor: const Color(0x2200D1B2),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.changeIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.home, color: Color(0xFF00D1B2)),
              label: 'Home',
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.SEARCH),
              child: NavigationDestination(
                icon: Icon(Icons.search, color: Colors.white70),
                selectedIcon: Icon(Icons.search, color: Color(0xFF00D1B2)),
                label: 'Search',
              ),
            ),
            GestureDetector(
              onTap: () {
                print("removing token");
                final box = GetStorage();
                box.remove('token');
              },
              child: NavigationDestination(
                icon: Icon(Icons.favorite_border, color: Colors.white70),
                selectedIcon: Icon(Icons.favorite, color: Color(0xFF00D1B2)),
                label: 'Favorites',
              ),
            ),
          ],
        ),
      ),
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

class _ShotCard extends StatelessWidget {
  const _ShotCard({required this.tags, required this.preview});

  final List<String> tags;
  final String preview;

  @override
  Widget build(BuildContext context) {
    final visibleTags = tags.take(2).toList();
    final remaining = tags.length - visibleTags.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: () => Get.toNamed(
          AppRoutes.IMAGE_VIEWER,
          arguments: {'imageUrl': preview, 'tags': tags},
        ),
        child: Container(
          color: Colors.white.withOpacity(0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              AspectRatio(
                aspectRatio: 1.2,
                child: Image.network(preview, fit: BoxFit.cover),
              ),

              /// TAG ROW (FIXED HEIGHT ✅)
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 28, // 👈 FIX: prevents overflow
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
