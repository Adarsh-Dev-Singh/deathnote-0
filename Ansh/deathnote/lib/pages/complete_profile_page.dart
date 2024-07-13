import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteProfilePage extends StatefulWidget {
  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String mobileNo = '';
  String name = '';
  String userAddress = '';
  String userImage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
                onChanged: (value) {
                  mobileNo = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onChanged: (value) {
                  userAddress = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'User Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your image URL';
                  }
                  return null;
                },
                onChanged: (value) {
                  userImage = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Get the current user
                    User? firebaseUser = FirebaseAuth.instance.currentUser;

                    if (firebaseUser != null) {
                      // Save profile data to Firestore
                      await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
                        'mobile_no': mobileNo,
                        'name': name,
                        'user_address': userAddress,
                        'user_id': firebaseUser.uid, // Set user ID from Firebase user
                        'user_image': userImage,
                      });

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile completed successfully!')),
                      );

                      Navigator.pop(context); // Go back to ProfilePage
                    }
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
