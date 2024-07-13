import 'package:cloud_firestore/cloud_firestore.dart';

class ArtCart {
  final String userId;
  final int artId;
  final String title;
  final String description;
  final String urlToImage;
  final double price;
  final String artistName;
  final String artStyle;

  ArtCart({
    required this.userId,
    required this.artId,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.price,
    required this.artistName,
    required this.artStyle
  });

  factory ArtCart.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return ArtCart(
      userId: data['user_id'],
      artId: data['art_id'],
      title: data['title'],
      description: data['description'],
      urlToImage: data['url_to_image'],
      price: data['price'].toDouble(),
      artistName: data['artist_name'],
      artStyle: data['art_style'],
    );
  }
}
