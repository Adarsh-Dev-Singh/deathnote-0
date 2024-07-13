import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deathnote/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:deathnote/models/art_cart.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    if (user == null) {
      return const Center(
        child: Text('No user logged in'),
      );
    }

    final userId = user.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('art_cart')
            .where('user_id', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items in cart'));
          } else {
            final cartItems = snapshot.data!.docs
                .map((doc) => ArtCart.fromSnapshot(doc))
                .toList();
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading:
                      Image.network(item.urlToImage, width: 50, height: 50),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    'Price: \$${item.price}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('art_cart')
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
