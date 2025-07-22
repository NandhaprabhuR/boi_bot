import 'package:bot/controllers/navigation_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import 'home_page.dart';
import 'history_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers here to ensure they are available to child pages
    final NavigationController navigationController = Get.put(NavigationController());
    Get.put(HistoryController());

    final List<Widget> pages = [
      HomePage(),
      HistoryPage(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navigationController.selectedIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            // --- Changes are here ---
            backgroundColor: Colors.black, // Set background color to black
            type: BottomNavigationBarType.fixed, // Ensures background color is applied
            unselectedItemColor: Colors.grey.shade600, // Make unselected items visible
            // --- End of changes ---

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
            currentIndex: navigationController.selectedIndex.value,
            selectedItemColor: Colors.white, // Keep selected item color
            onTap: navigationController.changePage,
          )),
    );
  }
}