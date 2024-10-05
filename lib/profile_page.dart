import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glance/auth/auth_service.dart';
import 'auth/login_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final auth = AuthService();
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  String? name;
  String? phone;
  String? email;
  String? photoURL;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  fetchUserDetails() async {
    DocumentSnapshot doc = await firestore.collection('user_details').doc(user?.uid).get();
    setState(() {
      name = doc['name'];
      phone = doc['phone'];
      email = doc['email'];
      photoURL = doc['photoURL'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(photoURL ?? ''),
            ),
            Text(
              name ?? '',
              style: const TextStyle(
                fontSize: 22.0,
              ),
            ),
            Text(
              email ?? '',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              phone ?? '',
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await auth.signout();
                goToLogin(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}