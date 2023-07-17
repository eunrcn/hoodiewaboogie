import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final cuisineController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load the existing user profile data
    loadUserProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    cuisineController.dispose();
    super.dispose();
  }

  void loadUserProfileData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    try {
      DocumentSnapshot<Map<String, dynamic>> userProfileSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('userProfile')
              .doc(userId)
              .get();

      if (userProfileSnapshot.exists) {
        Map<String, dynamic> userProfileData = userProfileSnapshot.data()!;
        String name = userProfileData['name'] ?? '';
        String cuisine = userProfileData['cuisine'] ?? '';

        nameController.text = name;
        cuisineController.text = cuisine;
      }
    } catch (e) {
      print('Error loading user profile data: $e');
    }
  }

  void updateProfile() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userProfile')
          .doc(userId)
          .update({
        'name': nameController.text,
        'cuisine': cuisineController.text,
      });

      // Display a success message or perform any other necessary actions

      // Navigate back to the Profile page
      Navigator.pop(context);
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: cuisineController,
              decoration: InputDecoration(labelText: 'Favorite Cuisine'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}