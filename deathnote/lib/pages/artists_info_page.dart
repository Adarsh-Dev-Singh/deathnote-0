import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArtistsInfoPage extends StatefulWidget {
  const ArtistsInfoPage({super.key});

  @override
  _ArtistsInfoPageState createState() => _ArtistsInfoPageState();
}

class _ArtistsInfoPageState extends State<ArtistsInfoPage> {
  final TextEditingController _usernameController = TextEditingController();
    Map<String, dynamic>? leetCodeData;
    Map<String, dynamic>? leetCodeData1;
    Map<String, dynamic>? leetCodeData2;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchLeetCodeStats(String username) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response1 = await http.get(
        Uri.parse('https://alfa-leetcode-api.onrender.com/userprofile/$username'),
      );
      final response2 = await http.get(
        Uri.parse('https://alfa-leetcode-api.onrender.com/$username'),
      );
      final response3 = await http.get(
        Uri.parse('https://alfa-leetcode-api.onrender.com/$username/contest'),
      );

      if (response1.statusCode == 200) {
        setState(() {
          leetCodeData = jsonDecode(response1.body);
          leetCodeData1 = jsonDecode(response2.body);
          leetCodeData2 = jsonDecode(response3.body);
          isLoading = false;
          
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load stats. Status Code: ${response1.statusCode}';
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
        title: const Text('LeetCode Stats'),
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
              // Username input field
              TextField(
                controller: _usernameController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Enter LeetCode Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              // Fetch stats button
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
              // Loading and error states
              if (isLoading) const CircularProgressIndicator(),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              if (leetCodeData != null && leetCodeData1 != null) ...[
                const SizedBox(height: 20),
                // Profile Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        leetCodeData1!['avatar']??'https://imgs.search.brave.com/_mGNdT6NF5aGVlIRb63izpdysyo3IlHzgrlyF3SUAVk/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/bWFnbnVzY2FybHNl/bi5jb20vc3RhdGlj/L2ltZy9iaW8vbWFn/bnVzLXByb2ZpbGUu/anBn',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Username Display
                Text(
                  leetCodeData1!['username'] ?? 'LeetCode User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  '☠️',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Stats section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${leetCodeData!['totalSolved']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Solved'),
                      ],
                    ),
                  
                    Column(
                      
                      children: [
                        Text(
                          
                          '${leetCodeData!['easySolved']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Medium Solved'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${leetCodeData!['ranking']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Ranking'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Additional stats
                Text('Contest Rating: ${leetCodeData2!['contestRating']}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
