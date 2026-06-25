import 'package:flutter/material.dart';
import 'package:deathnote/models/artwork.dart';
import 'package:deathnote/loader/json_service.dart';
import 'package:deathnote/views/full_art_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deathnote/services/auth/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ArtStyleView extends StatefulWidget {
  final String artStyle;

  ArtStyleView({required this.artStyle});

  @override
  _ArtStyleViewState createState() => _ArtStyleViewState();
}

class _ArtStyleViewState extends State<ArtStyleView> {
  late Future<List<Artwork>> futureArtworks;

  @override
  void initState() {
    super.initState();
    futureArtworks = loadJsonData();
  }

  Future<void> addToCart(Artwork artwork) async {
    final user = AuthService.firebase().currentUser!;

    final cartItem = {
      'user_id': user.id,
      'art_id': artwork.artId,
      'title': artwork.title,
      'description': artwork.description,
      'url_to_image': artwork.urlToImage,
      'price': artwork.price,
      'artist_name': artwork.artistName,
      'art_style': artwork.artStyle,
    };

    await FirebaseFirestore.instance.collection('art_cart').add(cartItem);
  }

  void _showAddToCartFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Art Style: ${widget.artStyle}'),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1539537127563-ef4adaf6e056?q=80&w=1854&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FutureBuilder<List<Artwork>>(
            future: futureArtworks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data found');
              } else {
                final artworks = snapshot.data!
                    .where((artwork) => artwork.artStyle == widget.artStyle)
                    .toList();
                return ListView.builder(
                  itemCount: artworks.length,
                  itemBuilder: (context, index) {
                    final artwork = artworks[index];

                    // Find similar artworks based on artist name and art style
                    final similarArtworks = artworks.where((a) =>
                      (a.artistName == artwork.artistName || a.artStyle == artwork.artStyle) && 
                      a.artId != artwork.artId
                    ).toList();

                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.125),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(artwork.urlToImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              artwork.title,
                              style: GoogleFonts.righteous(
                                color: Colors.white.withOpacity(0.98),
                                fontSize: 24,
                                textBaseline: TextBaseline.alphabetic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Artist: ${artwork.artistName}',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              'Price: \$${artwork.price}',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artwork.description,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullArtView(
                                          artwork: artwork,
                                          similarArtworks: similarArtworks,
                                        ),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.cyan,
                                    side: BorderSide(
                                        color: Colors.black.withOpacity(0.6)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text(
                                    'DETAILS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    await addToCart(artwork);
                                    _showAddToCartFeedback();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    elevation: 5,
                                    shadowColor:
                                        Colors.white.withOpacity(0.125),
                                  ),
                                  child: const Text(
                                    'ADD TO CART',
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
