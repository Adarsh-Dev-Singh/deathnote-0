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
  bool isEditMode = false;

  // Controllers for editable fields
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = AuthUser.fromFirebase(firebaseUser);
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((DocumentSnapshot doc) {
      if (doc.exists) {
        setState(() {
          userProfile = doc.data() as Map<String, dynamic>;
          // Populate controllers with the current user data
          _nameController.text = userProfile?['name'] ?? '';
          _mobileController.text = userProfile?['mobile_no'] ?? '';
          _addressController.text = userProfile?['user_address'] ?? '';
          _imageController.text = userProfile?['user_image'] ?? '';
        });
      }
    });
  }

  Future<void> _saveProfile() async {
    // Save updated data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).update({
      'name': _nameController.text,
      'leetcode_profile': _mobileController.text,
      'user_address': _addressController.text,
      'user_image': _imageController.text,
    });

    setState(() {
      isEditMode = false; // Exit edit mode after saving
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
                color: Colors.black,
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
        isEditMode
            ? TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Profile Image URL"),
              )
            : CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(userProfile!['user_image']),
              ),
        const SizedBox(height: 10),
        isEditMode
            ? TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              )
            : Text(
                '${userProfile!['name']}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
        isEditMode
            ? TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(labelText: "Mobile No"),
              )
            : Text(
                'LeetCode_Prodile_Name: ${userProfile!['mobile_no']}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
        isEditMode
            ? TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
              )
            : Text(
                'Address: ${userProfile!['user_address']}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
        const SizedBox(height: 20),
        isEditMode
            ? ElevatedButton(
                onPressed: _saveProfile,
                child: const Text("Save Changes"),
              )
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditMode = true; // Enable edit mode
                  });
                },
                child: const Text("Edit Profile"),
              ),
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
        ).then((_) => fetchUserProfile());
      },
      child: const Text("Complete Your Profile"),
    );
  }
}
