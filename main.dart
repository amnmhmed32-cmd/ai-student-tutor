import 'package:flutter/material.dart';
import 'http' as http;
import 'convert';

void main() {
  runApp(const AITutorApp());
}

class AITutorApp extends StatelessWidget {
  const AITutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethiopian AI Student Tutor',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final TextEditingController _controller = TextEditingController();
  String _response = "";
  bool _isLoading = false;

  Future<void> askAI() async {
    setState(() => _isLoading = true);
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/generate'),
      headers: {'Content-Type': 'json'},
      body: jsonEncode({'prompt': _controller.text, 'grade_level': 11}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _response = jsonDecode(response.body)['response'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Student Tutor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Ask a question...')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: askAI, child: const Text('Ask AI')),
            const SizedBox(height: 20),
            _isLoading ? const CircularProgressIndicator() : Text(_response),
          ],
        ),
      ),
    );
  }
}
