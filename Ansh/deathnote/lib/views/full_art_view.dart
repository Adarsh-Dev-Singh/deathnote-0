import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deathnote/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:deathnote/models/artwork.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Import for Timer

class FullArtView extends StatefulWidget {
  final Artwork artwork;
  final List<Artwork> similarArtworks;

  const FullArtView(
      {Key? key, required this.artwork, required this.similarArtworks})
      : super(key: key);

  @override
  _FullArtViewState createState() => _FullArtViewState();
}

class _FullArtViewState extends State<FullArtView> {
  bool _isAddedToCart = false; // Track the button state

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

  void _handleAddToCart() async {
    await addToCart(widget.artwork);
    setState(() {
      _isAddedToCart = true; // Change button text to "Added to Cart"
    });

    // Reset button text after 2 seconds
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isAddedToCart = false; // Revert back to original text
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Art View'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
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
                      image: NetworkImage(widget.artwork.urlToImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.artwork.title,
                  style: GoogleFonts.righteous(
                    color: Colors.white.withOpacity(0.98),
                    fontSize: 24,
                    textBaseline: TextBaseline.alphabetic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Artist: ${widget.artwork.artistName}',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Price: \$${widget.artwork.price}',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.artwork.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(
                  color: Colors.white.withOpacity(0.6),
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 16),
                Text(
                  'Details:',
                  style: GoogleFonts.lato(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailItem('Size', '20 inches x 20 inches'),
                _buildDetailItem('Medium', 'Acrylic color'),
                _buildDetailItem('Surface', 'Canvas Board'),
                _buildDetailItem('Artwork', 'Original'),
                _buildDetailItem('Created in', '2024'),
                _buildDetailItem('Quality', 'Museum Quality - 100% Hand-painted'),
                _buildDetailItem('To be delivered as', 'Box'),
                _buildDetailItem('Artist Sign and Certificate Provided', 'Yes'),
                const SizedBox(height: 16),
                Divider(
                  color: Colors.white.withOpacity(0.6),
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 16),
                Text(
                  'Return Policy:',
                  style: GoogleFonts.lato(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '7 days applicable from delivery date.',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _handleAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.95),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 5,
                    shadowColor: Colors.white.withOpacity(0.125),
                  ),
                  child: Text(
                    _isAddedToCart ? 'Added to Cart' : 'ADD TO CART',
                    style: const TextStyle(
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Divider(
                  color: Colors.white.withOpacity(0.6),
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 16),
                Text(
                  'Similar Paintings',
                  style: GoogleFonts.lato(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.similarArtworks.length,
                    itemBuilder: (context, index) {
                      final similarArtwork = widget.similarArtworks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullArtView(
                                artwork: similarArtwork,
                                similarArtworks: widget.similarArtworks,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(similarArtwork.urlToImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label + ':',
          style: GoogleFonts.lato(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
