import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Correct http import

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  final TextEditingController _usernameController = TextEditingController();
  Map<String, dynamic>? leetCodeData;
  Map<String, dynamic>? leetCodeData1;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchLeetCodeStats(String username) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response1 = await http.get(
        Uri.parse('https://api.chess.com/pub/player/$username'),
      );
      final response2 = await http.get(
        Uri.parse('https://api.chess.com/pub/player/$username/stats'),
      );

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        setState(() {
          leetCodeData = jsonDecode(response1.body);
          leetCodeData1 = jsonDecode(response2.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load stats. Status Code: ${response1.statusCode}, ${response2.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chesscom Stats'),
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Enter Chesscom Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final username = _usernameController.text.trim();
                  if (username.isNotEmpty) {
                    fetchLeetCodeStats(username);
                  }
                },
                child: const Text('Fetch Stats'),
              ),
              const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              if (leetCodeData != null && leetCodeData1 != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        leetCodeData!['avatar'] ?? 'https://imgs.search.brave.com/_mGNdT6NF5aGVlIRb63izpdysyo3IlHzgrlyF3SUAVk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cubWFnbnVzY2FybHNlbi5jb20vc3RhdGljL2ltZy9iaW8vbWFnbnVzLXByb2ZpbGUuanBn',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  leetCodeData!['name'] ?? 'Chesscom User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '☠️',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${leetCodeData1!['chess_rapid']['last']['rating']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Rapid'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${leetCodeData1!['chess_bullet']['last']['rating']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Bullet'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${leetCodeData1!['chess_blitz']['last']['rating']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Blitz'),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
