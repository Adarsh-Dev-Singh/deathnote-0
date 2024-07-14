import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deathnote/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:deathnote/models/art_cart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late Razorpay _razorpay;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _calculateTotal(List<ArtCart> cartItems) {
    _totalAmount = cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_Oa95jLPD02g5KJ',
      'amount': (_totalAmount * 100).toString(), // Razorpay works with paise
      'name': 'Artree',
      'description': 'Payment for your art items',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      },
    };

    _razorpay.open(options);
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final user = AuthService.firebase().currentUser;
    if (user != null) {
      final userId = user.id;
      final snapshot = await FirebaseFirestore.instance
          .collection('art_cart')
          .where('user_id', isEqualTo: userId)
          .get();

      // Delete all cart items after successful payment
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Notify user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    if (user == null) {
      return const Center(child: Text('No user logged in', style: TextStyle(color: Colors.white)));
    }

    final userId = user.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
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
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No items in cart', style: TextStyle(color: Colors.white)));
          } else {
            final cartItems = snapshot.data!.docs
                .map((doc) => ArtCart.fromSnapshot(doc))
                .toList();
            _calculateTotal(cartItems);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(item.urlToImage, width: 50, height: 50),
                        title: Text(item.title, style: const TextStyle(fontSize: 18, color: Colors.white)),
                        subtitle: Text('Price: \₹${item.price}', style: const TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('art_cart')
                                .doc(snapshot.data!.docs[index].id) // Get the document ID from snapshot
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item removed from cart')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _openCheckout,
                    child: Text('Pay Now (\₹${_totalAmount.toStringAsFixed(2)})', style: const TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
