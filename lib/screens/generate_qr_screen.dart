import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/history_service.dart';

class GenerateQRScreen extends StatefulWidget {
  const GenerateQRScreen({super.key});

  @override
  State<GenerateQRScreen> createState() =>
      _GenerateQRScreenState();
}

class _GenerateQRScreenState
    extends State<GenerateQRScreen> {
  final TextEditingController controller =
  TextEditingController();

  String qrData = "ScanNova Pro";

  Future<void> saveQR() async {
    final painter = QrPainter(
      data: qrData,
      version: QrVersions.auto,
      color: Colors.black,
      emptyColor: Colors.white,
    );

    final directory =
    await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/qr_code_hd.png",
    );

    final bytes =
    await painter.toImageData(
      3000,
      format: ImageByteFormat.png,
    );

    await file.writeAsBytes(
      bytes!.buffer.asUint8List(),
    );

    showMsg("QR Saved HD");
  }

  Future<void> shareQR() async {
    final painter = QrPainter(
      data: qrData,
      version: QrVersions.auto,
    );

    final directory =
    await getTemporaryDirectory();

    final file = File(
      "${directory.path}/share_qr.png",
    );

    final bytes =
    await painter.toImageData(
      3000,
      format: ImageByteFormat.png,
    );

    await file.writeAsBytes(
      bytes!.buffer.asUint8List(),
    );

    await Share.shareXFiles(
      [XFile(file.path)],
      text: qrData,
    );
  }

  Future<void> exportPDF() async {
    final pdf = pw.Document();

    final painter = QrPainter(
      data: qrData,
      version: QrVersions.auto,
    );

    final bytes =
    await painter.toImageData(
      3000,
      format: ImageByteFormat.png,
    );

    final image = pw.MemoryImage(
      bytes!.buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (_) => pw.Center(
          child: pw.Column(
            mainAxisAlignment:
            pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "ScanNova Pro",
                style:
                pw.TextStyle(
                  fontSize: 28,
                  fontWeight:
                  pw.FontWeight
                      .bold,
                ),
              ),
              pw.SizedBox(
                  height: 30),
              pw.Image(
                image,
                width: 300,
                height: 300,
              ),
              pw.SizedBox(
                  height: 20),
              pw.Text(qrData),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async =>
          pdf.save(),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Widget actionButton(
      IconData icon,
      String label,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
          color: Colors.white
              .withOpacity(0.18),
          borderRadius:
          BorderRadius.circular(
              22),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment
              .center,
          children: [
            Icon(
              icon,
              color:
              Colors.white,
              size: 34,
            ),
            const SizedBox(
                height: 8),
            Text(
              label,
              style:
              const TextStyle(
                color:
                Colors.white,
                fontWeight:
                FontWeight
                    .bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  void generateQR() {
    setState(() {
      qrData = controller
          .text
          .trim()
          .isEmpty
          ? "ScanNova Pro"
          : controller.text
          .trim();
    });

    HistoryService
        .saveGenerated(
        qrData);

    showMsg(
        "Saved to History");
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Generate QR"),
        centerTitle: true,
        backgroundColor:
        Colors.deepPurple,
      ),
      body: Container(
        width: double.infinity,
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
          ),
        ),
        child:
        SingleChildScrollView(
          padding:
          const EdgeInsets
              .all(20),
          child: Column(
            children: [
              const SizedBox(
                  height: 20),
              AnimatedContainer(
                duration:
                const Duration(
                    milliseconds:
                    600),
                padding:
                const EdgeInsets
                    .all(25),
                decoration:
                BoxDecoration(
                  color: Colors
                      .white
                      .withOpacity(
                      0.18),
                  borderRadius:
                  BorderRadius
                      .circular(
                      30),
                ),
                child:
                QrImageView(
                  data: qrData,
                  size: 250,
                  backgroundColor:
                  Colors.white,
                ),
              ),
              const SizedBox(
                  height: 35),
              TextField(
                controller:
                controller,
                style:
                const TextStyle(
                  color:
                  Colors.white,
                ),
                decoration:
                InputDecoration(
                  hintText:
                  "Enter text / URL",
                  filled: true,
                  fillColor:
                  Colors.white
                      .withOpacity(
                      0.15),
                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        20),
                  ),
                ),
              ),
              const SizedBox(
                  height: 25),
              SizedBox(
                width:
                double.infinity,
                height: 55,
                child:
                ElevatedButton(
                  onPressed:
                  generateQR,
                  child:
                  const Text(
                    "Generate QR",
                  ),
                ),
              ),
              const SizedBox(
                  height: 35),
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceEvenly,
                children: [
                  actionButton(
                    Icons.save,
                    "Save",
                    saveQR,
                  ),
                  actionButton(
                    Icons.share,
                    "Share",
                    shareQR,
                  ),
                  actionButton(
                    Icons.picture_as_pdf,
                    "PDF",
                    exportPDF,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}