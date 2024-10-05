import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class BlogFromCarousel extends StatefulWidget {
  final String doc_id;

  const BlogFromCarousel({Key? key, required this.doc_id}) : super(key: key);

  @override
  State<BlogFromCarousel> createState() => _BlogFromCarouselState();
}

class _BlogFromCarouselState extends State<BlogFromCarousel> {
  String? image;
  String? title;
  String? id;
  // String? content;

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('dummyCaro');
      QuerySnapshot querySnapshot = await collection.get();

      for (DocumentSnapshot document in querySnapshot.docs) {
        if (widget.doc_id == document.id) {
          image = document.get('Image');
          title = document.get('Title');
          id = document.id;
          // content = document.get('Content');
          break; // Exit the loop once the matching document is found
        }
        // content = document.get('Content');
      }
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  toolbarHeight: 10,
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundColor: Colors.transparent,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          Image.network(image!, fit: BoxFit.cover, height: 400.0, width: double.infinity,),
                          getLabelData(),
                        ],
                      ),
                      Container(height: 1000, color: Colors.blue,)
                    ],
                  ),
                ),
              ),
              getBackButton()
            ],
          );
        }
      },
    );
  }

  Widget getBackButton() {
    return Positioned(
      top: 50.0,
      left: 10.0,
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        color: Colors.transparent,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget getLabelData() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(50, 0, 0, 0)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.center,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Text(
          title ?? '', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 40),
        ),
      ),
    );
  }

}
