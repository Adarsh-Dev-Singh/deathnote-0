import 'package:deathnote/constants/routes.dart';
import 'package:deathnote/enums/menu_action.dart';
import 'package:deathnote/services/auth/auth_service.dart';
import 'package:deathnote/services/auth/bloc/auth_bloc.dart';
import 'package:deathnote/services/auth/bloc/auth_event.dart';
import 'package:deathnote/utilities/dialog/logout_dialog.dart';
import 'package:deathnote/views/full_art_view.dart';
import 'package:flutter/material.dart';
import 'package:deathnote/models/artwork.dart';
import 'package:deathnote/loader/json_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async'; // Import for Timer

class ArtView extends StatefulWidget {
  const ArtView({super.key});

  @override
  _ArtViewState createState() => _ArtViewState();
}

class _ArtViewState extends State<ArtView> {
  late Future<List<Artwork>> futureArtworks;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  List<Artwork> _filterArtworks(List<Artwork> artworks) {
    if (_searchQuery.isEmpty) {
      return artworks;
    }
    return artworks.where((artwork) {
      final titleLower = artwork.title.toLowerCase();
      final artistNameLower = artwork.artistName.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return titleLower.contains(searchLower) || artistNameLower.contains(searchLower);
    }).toList();
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
        title: const Text('Arts'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(cartRoute);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search by art name or artist name',
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
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
                    final artworks = _filterArtworks(snapshot.data!);
                    return ListView.builder(
                      itemCount: artworks.length,
                      itemBuilder: (context, index) {
                        final artwork = artworks[index];
                        final similarArtworks = artworks.where((a) => a.artistName == artwork.artistName && a.artId != artwork.artId).toList();
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
                                        side: BorderSide(color: Colors.black.withOpacity(0.6)),
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
                                        backgroundColor: Colors.black.withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        elevation: 5,
                                        shadowColor: Colors.white.withOpacity(0.125),
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
          ],
        ),
      ),
    );
  }
}
