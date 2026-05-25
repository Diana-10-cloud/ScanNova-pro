import 'package:flutter/material.dart';
import 'generate_qr_screen.dart';
import 'scan_qr_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'Generate QR',
        'icon': Icons.qr_code
      },
      {
        'title': 'Scan QR',
        'icon':
        Icons.qr_code_scanner
      },
      {
        'title': 'History',
        'icon': Icons.history
      },
      {
        'title': 'Settings',
        'icon': Icons.settings
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar:
      true,

      appBar: AppBar(
        backgroundColor:
        Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "ScanNova Pro",
          style: TextStyle(
            fontWeight:
            FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      body: Container(
        decoration:
        const BoxDecoration(
          gradient:
          LinearGradient(
            colors: [
              Colors
                  .deepPurple,
              Colors
                  .blueAccent
            ],
            begin:
            Alignment
                .topLeft,
            end:
            Alignment
                .bottomRight,
          ),
        ),

        child: GridView.builder(
          padding:
          const EdgeInsets
              .only(
            top: 100,
            left: 20,
            right: 20,
            bottom: 20,
          ),

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
            2,
            crossAxisSpacing:
            20,
            mainAxisSpacing:
            20,
          ),

          itemCount:
          features.length,

          itemBuilder:
              (context,
              index) {
            return TweenAnimationBuilder<
                double>(
              tween: Tween(
                begin: 0.8,
                end: 1.0,
              ),

              duration:
              Duration(
                milliseconds:
                500 +
                    (index *
                        200),
              ),

              builder: (_,
                  value,
                  child) {
                return Transform
                    .scale(
                  scale:
                  value,
                  child:
                  child,
                );
              },

              child:
              GestureDetector(
                onTap: () {
                  if (index ==
                      0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                        const GenerateQRScreen(),
                      ),
                    );
                  }

                  else if (index ==
                      1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                        const ScanQRScreen(),
                      ),
                    );
                  }

                  else if (index ==
                      2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                        const HistoryScreen(),
                      ),
                    );
                  }

                  else if (index ==
                      3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                        const SettingsScreen(),
                      ),
                    );
                  }
                },

                child:
                Container(
                  decoration:
                  BoxDecoration(
                    color: Colors
                        .white
                        .withOpacity(
                        0.15),

                    borderRadius:
                    BorderRadius.circular(
                        25),

                    border:
                    Border.all(
                      color:
                      Colors.white24,
                    ),

                    boxShadow:
                    const [
                      BoxShadow(
                        blurRadius:
                        20,
                        spreadRadius:
                        2,
                        color: Colors
                            .black26,
                      ),
                    ],
                  ),

                  child:
                  Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(
                        features[index]
                        [
                        'icon']
                        as IconData,
                        size:
                        55,
                        color:
                        Colors.white,
                      ),

                      const SizedBox(
                          height:
                          20),

                      Text(
                        features[index]
                        [
                        'title']
                        as String,
                        style:
                        const TextStyle(
                          color:
                          Colors.white,
                          fontSize:
                          18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar:
      BottomNavigationBar(
        backgroundColor:
        Colors.black87,
        selectedItemColor:
        Colors.white,
        unselectedItemColor:
        Colors.white54,

        items: const [
          BottomNavigationBarItem(
            icon:
            Icon(Icons.home),
            label:
            "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.qr_code),
            label:
            "Generate",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons
                .qr_code_scanner),
            label:
            "Scan",
          ),
        ],
      ),
    );
  }
}