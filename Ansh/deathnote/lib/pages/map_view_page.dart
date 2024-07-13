import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:deathnote/loader/load_data.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  late Future<List<Map<String, dynamic>>> futureArtists;
  double currentZoom = 5; // Initial zoom level

  @override
  void initState() {
    super.initState();
    futureArtists = loadArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Artists")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureArtists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final artists = snapshot.data!;
            return FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(22.0046661, 79.625980),
                initialZoom: currentZoom,
                onPositionChanged: (position, hasGesture) {
                  setState(() {
                    currentZoom = position.zoom;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: artists.map((artist) {
                    return Marker(
                      point: LatLng(artist['Latitude'], artist['Longitude']),
                      width: 240,
                      height: 80,
                      child: Builder(
                        builder: (context) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               
                                 if (currentZoom >= 6) //
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(artist['image_url']),
                                  ),
                                const Icon(
                                  Icons.location_on,
                                  size: 40,
                                ),
                                if (currentZoom >=
                                    7) // Conditional display based on zoom
                                  Text(
                                    artist['artist_name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
