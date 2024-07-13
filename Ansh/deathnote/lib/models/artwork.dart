// lib/models/artwork.dart

class Artwork {
  final int artId;
  final String title;
  final String description;
  final String urlToImage;
  final double price;
  final String artistName;
  final String artStyle;

  Artwork({
    required this.artId,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.price,
    required this.artistName,
    required this.artStyle,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      artId: json['art_id'],
      title: json['title'],
      description: json['description'],
      urlToImage: json['url_to_image'],
      price: json['price'].toDouble(),
      artistName: json['artist_name'],
      artStyle: json['art_style'],
    );
  }
}
