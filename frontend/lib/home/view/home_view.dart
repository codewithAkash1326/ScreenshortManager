import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _SearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.shots.isEmpty) {
                    return const Center(
                      child: Text(
                        'No screenshots yet',
                        style: TextStyle(color: Colors.white70),
                      ),
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
                      return _ShotCard(tag: shot.tag, preview: shot.preview);
                    },
                  );
                }),
              ),
            ],
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
            NavigationDestination(
              icon: Icon(Icons.search, color: Colors.white70),
              selectedIcon: Icon(Icons.search, color: Color(0xFF00D1B2)),
              label: 'Search',
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
  const _ShotCard({required this.tag, required this.preview});

  final String tag;
  final String preview;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.white.withOpacity(0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2, // smaller height
              child: Image.network(
                preview,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white12,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                  ),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                '#$tag',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
