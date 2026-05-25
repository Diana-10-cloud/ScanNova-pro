import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import '../services/history_service.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() =>
      _ScanQRScreenState();
}

class _ScanQRScreenState
    extends State<ScanQRScreen> {
  final MobileScannerController
  controller =
  MobileScannerController();

  final ImagePicker picker =
  ImagePicker();

  bool isScanning = true;
  String scannedData = "";

  Future<void> openLink() async {
    final Uri uri =
    Uri.parse(scannedData);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode:
        LaunchMode
            .externalApplication,
      );
    }
  }

  void shareLink() {
    Share.share(
      scannedData,
    );
  }

  Future<void>
  scanFromGallery() async {
    final XFile? image =
    await picker.pickImage(
      source:
      ImageSource.gallery,
    );

    if (image == null) return;

    final result =
    await controller
        .analyzeImage(
        image.path);

    if (result != null &&
        result.barcodes
            .isNotEmpty) {
      final code = result
          .barcodes.first
          .rawValue;

      if (code != null) {
        showResult(code);
      }
    } else {
      ScaffoldMessenger.of(
          context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "No QR found",
          ),
        ),
      );
    }
  }

  void showResult(
      String result) {
    if (!isScanning) return;

    isScanning = false;

    controller.stop();

    scannedData = result;

    HistoryService
        .saveScanned(
        result);

    setState(() {});

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor:
      Colors.deepPurple,
      shape:
      const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top:
          Radius.circular(
              30),
        ),
      ),
      builder: (_) {
        return Padding(
          padding:
          const EdgeInsets
              .all(20),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              const Text(
                "Scan Result",
                style:
                TextStyle(
                  color:
                  Colors
                      .white,
                  fontSize:
                  22,
                  fontWeight:
                  FontWeight
                      .bold,
                ),
              ),
              const SizedBox(
                  height: 20),
              SelectableText(
                scannedData,
                style:
                const TextStyle(
                  color:
                  Colors
                      .white,
                ),
              ),
              const SizedBox(
                  height: 25),
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                    openLink,
                    child:
                    const Text(
                      "Open",
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                    shareLink,
                    child:
                    const Text(
                      "Share",
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () {
                      Navigator.pop(
                          context);

                      controller
                          .start();

                      isScanning =
                      true;

                      setState(
                              () {});
                    },
                    child:
                    const Text(
                      "Again",
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext
      context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          "Scan QR",
        ),
        centerTitle:
        true,
        backgroundColor:
        Colors
            .deepPurple,
        actions: [
          IconButton(
            onPressed:
            scanFromGallery,
            icon:
            const Icon(
              Icons
                  .photo_library,
            ),
          ),
        ],
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
                  .blueAccent,
            ],
          ),
        ),
        child: Padding(
          padding:
          const EdgeInsets
              .all(20),
          child:
          ClipRRect(
            borderRadius:
            BorderRadius
                .circular(
                25),
            child:
            MobileScanner(
              controller:
              controller,
              onDetect:
                  (
                  capture,
                  ) {
                final barcode =
                    capture
                        .barcodes
                        .first;

                if (barcode
                    .rawValue !=
                    null) {
                  showResult(
                    barcode
                        .rawValue!,
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        backgroundColor:
        Colors.white,
        foregroundColor:
        Colors.deepPurple,
        onPressed:
        scanFromGallery,
        child: const Icon(
          Icons
              .image_search,
        ),
      ),
    );
  }
}