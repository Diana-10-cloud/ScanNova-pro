import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      'icon': Icons.qr_code,
      'title': 'Generate Stylish QR',
      'subtitle': 'Create premium animated QR designs instantly'
    },
    {
      'icon': Icons.qr_code_scanner,
      'title': 'Scan Instantly',
      'subtitle': 'Fast smart scanner from camera or gallery'
    },
    {
      'icon': Icons.picture_as_pdf,
      'title': 'Export & Share PDF',
      'subtitle': 'Professional branded PDF QR export'
    },
    {
      'icon': Icons.workspace_premium,
      'title': 'Unlock Premium',
      'subtitle': 'No ads + unlimited customization'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => currentPage = index);
            },
            itemBuilder: (_, index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade700,
                      Colors.blue.shade400,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pages[index]['icon'],
                      size: 150,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      pages[index]['title'],
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        pages[index]['subtitle'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text('Skip',style: TextStyle(color: Colors.white)),
                ),
                Row(
                  children: List.generate(
                    pages.length,
                        (index) => Container(
                      margin: const EdgeInsets.all(4),
                      width: currentPage == index ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentPage == pages.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    } else {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(currentPage == pages.length - 1
                      ? 'Start'
                      : 'Next'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// MAIN ROUTES
// lib/main.dart
