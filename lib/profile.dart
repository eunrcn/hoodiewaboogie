import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hoodie_w_a_boogie/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userProfile')
          .doc(userId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading profile data'),
          );
        }

        final data = snapshot.data?.data();
        final name = data?['name'] ?? 'Name';
        final favoriteCuisine = data?['cuisine'] ?? 'Favorite Cuisine';
        final email = FirebaseAuth.instance.currentUser?.email ?? 'Email';

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/profile_image.jpg'),
                ),
                SizedBox(height: 20),
                Text(
                  name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (favoriteCuisine != null &&
                    favoriteCuisine != 'Favorite Cuisine')
                  Text(
                    'Favorite Cuisine: ',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                Text(
                  favoriteCuisine ?? '',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(email),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
