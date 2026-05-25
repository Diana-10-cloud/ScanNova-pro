import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  late Box settingsBox;

  bool cloudBackup = false;

  @override
  void initState() {
    super.initState();

    settingsBox =
        Hive.box('historyBox');

    cloudBackup =
        settingsBox.get(
          'cloudBackup',
          defaultValue: false,
        ) ??
            false;
  }

  void toggleBackup(
      bool value) {
    setState(() {
      cloudBackup = value;
    });

    settingsBox.put(
      'cloudBackup',
      value,
    );

    ScaffoldMessenger.of(
        context)
        .showSnackBar(
      SnackBar(
        content: Text(
          value
              ? "Cloud Backup Enabled"
              : "Cloud Backup Disabled",
        ),
      ),
    );
  }

  Widget tile(
      String title,
      IconData icon,
      Widget trailing,
      ) {
    return Container(
      margin:
      const EdgeInsets.only(
          bottom: 18),
      decoration:
      BoxDecoration(
        color: Colors.white
            .withOpacity(
            0.15),
        borderRadius:
        BorderRadius.circular(
            22),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
          Colors.white,
        ),
        title: Text(
          title,
          style:
          const TextStyle(
            color:
            Colors.white,
            fontWeight:
            FontWeight.bold,
          ),
        ),
        trailing:
        trailing,
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          "Settings",
        ),
        centerTitle:
        true,
        backgroundColor:
        Colors.deepPurple,
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
          ),
        ),
        child: Padding(
          padding:
          const EdgeInsets
              .all(20),
          child: Column(
            children: [
              const SizedBox(
                  height: 25),

              tile(
                "Cloud Backup",
                Icons.cloud_upload,
                Switch(
                  value:
                  cloudBackup,
                  onChanged:
                  toggleBackup,
                ),
              ),

              tile(
                "Restore Backup",
                Icons.restore,
                ElevatedButton(
                  onPressed:
                      () {
                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Backup Restored",
                        ),
                      ),
                    );
                  },
                  child:
                  const Text(
                    "Restore",
                  ),
                ),
              ),

              tile(
                "Version",
                Icons.info,
                const Text(
                  "v1.0.0",
                  style:
                  TextStyle(
                    color: Colors
                        .white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}