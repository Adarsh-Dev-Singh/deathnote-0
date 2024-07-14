import 'package:deathnote/constants/routes.dart';
import 'package:deathnote/enums/menu_action.dart';
import 'package:deathnote/services/auth/bloc/auth_bloc.dart';
import 'package:deathnote/services/auth/bloc/auth_event.dart';
import 'package:deathnote/utilities/dialog/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:deathnote/views/art_style_view.dart';
import 'package:deathnote/models/artwork.dart';
import 'package:deathnote/loader/json_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Artwork>> futureArtworks;

  @override
  void initState() {
    super.initState();
    futureArtworks = loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArTree🎨🌳'),
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
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1539537127563-ef4adaf6e056?q=80&w=1854&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Empowering Traditional Artisans ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'by Enabling them to Bring a Piece of India in Every Home.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Artwork>>(
                future: futureArtworks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data found'));
                  } else {
                    final artworks = snapshot.data!;
                    final artStyles = artworks
                        .map((artwork) => artwork.artStyle)
                        .toSet()
                        .toList();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: artStyles.length,
                      itemBuilder: (context, index) {
                        final style = artStyles[index];
                        final firstArtwork = artworks.firstWhere(
                          (artwork) => artwork.artStyle == style,
                          orElse: () => artworks.first,
                        );

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArtStyleView(artStyle: style),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(firstArtwork.urlToImage),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                  child: Text(
                                    style,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.cyan),
              const Text(
                'About Artree',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Artree is a "culture-tech" platform dedicated to empowering traditional rural artisans from the remotest corners of India to become digital creators. Through online art & craft masterclasses, live classes, and eCommerce, we provide artisans with new income streams and sustainable livelihoods. With a mission to be the largest global platform for Indian heritage art and craft, Artree connects our artistic heritage with the world, bringing a piece of India into every home.',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.cyan),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Customer Queries: arttree001@gmail.com\n'
                'WhatsApp: +91 6006972774\n'
                'Mailing Address: Arttree Retail and Tech Pvt Ltd\n'
                'NH-3 B.M.S HOSTEL, Just Vend Store, Hanumanth Nagar, Basavanagudi, 560019\n',
                
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                '\n'
                '\n',
                
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(color: Colors.cyan),
            ],
          ),
        ),
      ),
    );
  }
}
