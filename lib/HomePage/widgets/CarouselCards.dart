import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class CarouselCards extends StatelessWidget {
  CarouselCards({super.key});
  final CarouselSliderController carouselController = CarouselSliderController();
  final List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widgets,
      carouselController: carouselController,
      options: CarouselOptions(
          autoPlay: true,
          height: 200,
          scrollPhysics: const BouncingScrollPhysics(),
          enlargeCenterPage: true,
          viewportFraction: 0.84,
          onPageChanged: (index, reason) {
            // setState(() {
            //   currIndex = index;
            //   // print(currIndex);
            // });
          }),
    );
  }
}
