import 'package:deathnote/pages/complete_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deathnote/services/auth/auth_user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User firebaseUser = FirebaseAuth.instance.currentUser!;
  AuthUser? currentUser;
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    currentUser = AuthUser.fromFirebase(firebaseUser);
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    // Use a listener to get updates
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((DocumentSnapshot doc) {
      if (doc.exists) {
        setState(() {
          userProfile = doc.data() as Map<String, dynamic>;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              currentUser?.email ?? '',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            userProfile != null
                ? _buildUserProfile()
                : _buildCompleteProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(userProfile!['user_image']),
        ),
        Text('${userProfile!['name']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            )),
        Text('Mobile: ${userProfile!['mobile_no']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            )),
        Text('Address: ${userProfile!['user_address']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            )),
      ],
    );
  }

  Widget _buildCompleteProfileButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteProfilePage(),
          ),
        ).then((_) {
          // Fetch user profile again after returning from CompleteProfilePage
          fetchUserProfile();
        });
      },
      child: const Text("Complete Your Profile"),
    );
  }
}
