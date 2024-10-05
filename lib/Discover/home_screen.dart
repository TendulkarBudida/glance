import 'package:flutter/material.dart';
import 'package:glance/Discover/events.dart';

import 'package:glance/auth/auth_service.dart';
import 'package:glance/auth/login_screen.dart';
import '../profile_page.dart';
import 'discover.dart';
import 'heat_map.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  User? user = FirebaseAuth.instance.currentUser;
  final auth = AuthService();

  static const List<Widget> _widgetOptions = <Widget>[
    Discover(),
    Events(),
    Text('Heat Map'),
    Text('Clubs Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // This makes the AppBar transparent
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getProfilePage(),
              ],
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.circle_outlined),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_seat_outlined),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Heat Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                label: 'Clubs',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );

  goToProfile(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ProfilePage()),
  );

  Widget getProfilePage() {
    return FutureBuilder(
      future: fetchProfilePictureUrl(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return GestureDetector(
            onTap: () {
              goToProfile(context);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,  // Specify border color
                  width: 3.0,   // Specify border thickness
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data ?? ''),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> fetchProfilePictureUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    final storage = FirebaseStorage.instance;
    String? photoURL;

    if (user != null) {
      Reference ref = storage.ref().child('user_photos').child(user.uid);
      photoURL = await ref.getDownloadURL();
    }

    return photoURL ?? '';
  }
}

