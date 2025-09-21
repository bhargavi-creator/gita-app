import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const GitaApp());
}

class GitaApp extends StatelessWidget {
  const GitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bhagavad Gita',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List chapters = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    String data = await rootBundle.loadString('assets/gita.json');
    final jsonResult = json.decode(data);
    setState(() {
      chapters = jsonResult["chapters"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bhagavad Gita")),
      body: ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return Card(
            color: Colors.orange.shade100, // 👈 background color for each card
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                "Chapter ${chapter['number']}: ${chapter['name']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SlokasScreen(chapter: chapter),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SlokasScreen extends StatelessWidget {
  final Map chapter;
  const SlokasScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final slokas = chapter["slokas"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Chapter ${chapter['number']}"),
      ),
      body: ListView.builder(
        itemCount: slokas.length,
        itemBuilder: (context, index) {
          final sloka = slokas[index];
            final colors = [
              Colors.pink.shade50,
              Colors.blue.shade50,
              Colors.green.shade50,
              Colors.purple.shade50,
              Colors.orange.shade50,
            ];

            return Card(
              color: colors[index % colors.length], // pastel background
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sloka ${sloka['number']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sloka['sanskrit'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sloka['translation'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
