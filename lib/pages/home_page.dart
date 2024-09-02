import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/big_card.dart';
import 'gallery_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.onTap});
  final Function() onTap;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> widgets = [
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
    BigCard(
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Youth-soccer-indiana.jpg/1200px-Youth-soccer-indiana.jpg',
      name: 'ANIME CLUB',
      clubName: 'anime',
      imageHeight: 200,
      imageWidth: 300,
      text: 'hello',
      subName: 'hello',
      radius: 20,
      fit: BoxFit.cover,
    ),
  ];

  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(height: 10),
                CarouselSlider(
                  items: widgets,
                  carouselController: carouselController,
                  options: CarouselOptions(
                    autoPlay: true,
                      height: 200,
                      scrollPhysics: const BouncingScrollPhysics(),
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        // setState(() {
                        //   currIndex = index;
                        //   // print(currIndex);
                        // });
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 28.0, bottom: 8.0),
                  child: Text(
                    "Gallery",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('gallery')
                      .limit(6)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData) {
                      var documents = snapshot.data!.docs;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: documents.asMap().entries.map((entry) {
                            int index = entry.key; // Current index
                            var doc = entry.value; // Current document

                            var imageUrl = doc[
                                'ImageUrl']; // Assuming 'ImageUrl' is the field name in Firestore

                            return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: (index != 5)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          imageUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.network(
                                              imageUrl,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Opacity(
                                            opacity: 0.93,
                                            child: InkWell(
                                              onTap: widget.onTap,
                                              child: Container(

                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(

                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color: Colors.grey.shade700,
                                                      size: 30,
                                                    ),
                                                    Text(
                                                      'See more',
                                                      style: TextStyle(
                                                          color: Colors.grey.shade700, fontWeight: FontWeight.bold
                                                      ),

                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ));
                          }).toList(),
                        ),
                      );
                    } else {
                      return const Center(child: Text('No Images Available'));
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 28.0, bottom: 8.0),
                  child: Text(
                    "Sponsor",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/images/ceat.png', width: 180,height: 60, fit:BoxFit.cover,),
                    Image.asset('assets/images/cred.png', width: 180, height: 80, fit:BoxFit.cover,),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset('assets/images/tata.png', width: 150,height: 60, fit:BoxFit.cover,),
                    Image.asset('assets/images/vivo.png', width: 190, height: 80, fit:BoxFit.cover,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 8.0),
                  child: Text(
                    "Connect With Us",
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
