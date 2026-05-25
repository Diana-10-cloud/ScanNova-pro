import 'package:hive/hive.dart';

class HistoryService {
  static Box get box => Hive.box('historyBox');

  /// SAVE GENERATED QR
  static Future<void> saveGenerated(String data) async {
    await box.add({
      'type': 'generated',
      'data': data,
      'time': DateTime.now().toString(),
    });
  }

  /// SAVE SCANNED QR
  static Future<void> saveScanned(String data) async {
    await box.add({
      'type': 'scanned',
      'data': data,
      'time': DateTime.now().toString(),
    });
  }

  /// CLEAR ALL HISTORY
  static Future<void> clearAll() async {
    await box.clear();
  }
}