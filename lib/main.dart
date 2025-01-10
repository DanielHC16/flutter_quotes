import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Daily Inspirational Quote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _quote = 'Fetching quote...';
  String _author = '';

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    try {
      // Fetch a random quote
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('quotes')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final randomDoc = snapshot.docs.first; // Pick the first for simplicity
        setState(() {
          _quote = randomDoc['Quote'];
          _author = randomDoc['Author'];
        });
      } else {
        setState(() {
          _quote = 'No quotes found in Firestore.';
        });
      }
    } catch (e) {
      setState(() {
        _quote = 'Error fetching quote: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _quote,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Text(
              '- $_author',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
