import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

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
      appBar: AppBar(
        title: const Text("Complete Your Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Enter your mobile number',
                  hintStyle: TextStyle(color: Colors.white),
                ),
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
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(color: Colors.white),
                ),
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
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Enter your address',
                  hintStyle: TextStyle(color: Colors.white),
                ),
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
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'User Image URL',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Enter the image URL',
                  hintStyle: TextStyle(color: Colors.white),
                ),
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
                    User? firebaseUser = FirebaseAuth.instance.currentUser;

                    if (firebaseUser != null) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(firebaseUser.uid)
                          .set({
                        'mobile_no': mobileNo,
                        'name': name,
                        'user_address': userAddress,
                        'user_id': firebaseUser.uid,
                        'user_image': userImage,
                      });

                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile completed successfully!')),
                      );

                      // ignore: use_build_context_synchronously
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
