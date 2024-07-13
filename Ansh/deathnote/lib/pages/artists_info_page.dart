import 'dart:convert';

import 'package:flutter/material.dart';

class ArtistsInfoPage extends StatelessWidget {
  const ArtistsInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/artists.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        } else {
          var artistsJson = jsonDecode(snapshot.data.toString());
          var artistsList = artistsJson['artists'];

          return ListView.builder(
            itemCount: artistsList.length,
            itemBuilder: (context, index) {
              var artist = artistsList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(artist['image_url']),
                  ),
                  title: Text(artist['artist_name']),
                  subtitle: Text(
                    artist['artist_description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    // Navigate to artist details page if needed
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
