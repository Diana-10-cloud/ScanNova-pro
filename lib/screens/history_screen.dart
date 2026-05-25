import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Box historyBox;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 2,
      vsync: this,
    );

    historyBox = Hive.box('historyBox');
  }

  List<Map> getGenerated() {
    return historyBox.keys
        .map((key) {
      final data = historyBox.get(key);

      if (data == null) return null;

      final map =
      Map<String, dynamic>.from(data);

      return {
        'key': key,
        ...map,
      };
    })
        .whereType<Map>()
        .where((e) => e['type'] == 'generated')
        .toList();
  }

  List<Map> getScanned() {
    return historyBox.keys
        .map((key) {
      final data = historyBox.get(key);

      if (data == null) return null;

      final map =
      Map<String, dynamic>.from(data);

      return {
        'key': key,
        ...map,
      };
    })
        .whereType<Map>()
        .where((e) => e['type'] == 'scanned')
        .toList();
  }

  Future<void> deleteItem(dynamic key) async {
    await historyBox.delete(key);
    setState(() {});
  }

  Widget buildList(List<Map> data, String type) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          "No History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: data.length,
      itemBuilder: (_, index) {
        final item = data[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Icon(
              type == "generated"
                  ? Icons.qr_code
                  : Icons.qr_code_scanner,
              color: Colors.white,
            ),
            title: Text(
              item['data'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              item['time'].toString(),
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("View Result"),
                  content: SelectableText(
                    item['data'].toString(),
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                deleteItem(item['key']);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "Generated"),
            Tab(text: "Scanned"),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.blueAccent,
            ],
          ),
        ),
        child: TabBarView(
          controller: tabController,
          children: [
            buildList(getGenerated(), "generated"),
            buildList(getScanned(), "scanned"),
          ],
        ),
      ),
    );
  }
}