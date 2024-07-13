// lib/services/json_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:deathnote/models/artwork.dart';

Future<List<Artwork>> loadJsonData() async {
  final String response = await rootBundle.loadString('assets/artworks.json');
  final data = await json.decode(response) as List;
  return data.map((json) => Artwork.fromJson(json)).toList();
}
