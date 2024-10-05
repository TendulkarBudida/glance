import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'blog_from_carousel.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {

  final List<String> imgList = [];
  final List<String> titleList = [];
  final List<String> idList = [];

  final carousel.CarouselSliderController _controller = carousel.CarouselSliderController();

  @override
  void initState() {
    super.initState();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('dummyCaro');

      QuerySnapshot querySnapshot = await collection.get();

      imgList.clear();
      titleList.clear();
      idList.clear();

      for (DocumentSnapshot document in querySnapshot.docs) {
        String? image = document.get('Image');
        String? title = document.get('Title');
        String? id = document.id;

        if (image != null && title != null) {
          imgList.add(image);
          titleList.add(title);
          idList.add(id);
        }

        print(imgList);
        print(titleList);
        print(idList);
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: getGreetingByTime(),
                ), const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: getWhatsHappening(),
                ), const SizedBox(height: 10),
                getCarousel(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget getGreetingByTime() {
    final hour = DateTime.now().hour;

    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    const gradient = LinearGradient(
      colors: <Color>[Colors.blue, Colors.purple, Colors.red],
    );

    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        greeting,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 50.0),
      ),
    );
  }

  Widget getWhatsHappening() {
    return Text(
      'What\'s Happening?',
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget getCarousel() {
    final List<Widget> imageSliders = imgList.map((item) => GestureDetector(
      onTap: () {
        print('Tapped on: $item');
        print('Title: ${titleList[imgList.indexOf(item)]}');
        print('ID: ${idList[imgList.indexOf(item)]}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BlogFromCarousel(doc_id: idList[imgList.indexOf(item)])),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      titleList[imgList.indexOf(item)],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    )).toList();

    return carousel.CarouselSlider(
      options: carousel.CarouselOptions(
        aspectRatio: 9 / 16,
        height: 400,

        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
        enableInfiniteScroll: true,
      ),
      carouselController: _controller,
      items: imageSliders,
    );
  }
}
