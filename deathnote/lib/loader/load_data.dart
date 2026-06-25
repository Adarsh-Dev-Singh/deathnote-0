import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> loadArtists() async {
  final String response = await rootBundle.loadString('assets/artists.json');
  final data = await json.decode(response);
  return List<Map<String, dynamic>>.from(data['artists']);
}
