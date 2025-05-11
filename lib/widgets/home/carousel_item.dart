import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselItem extends StatelessWidget {
  final List<Map<String, String>> items;
  final bool useCarousel;
  final Widget Function(Map<String, String>) itemBuilder;

  const CarouselItem({
    super.key,
    required this.items,
    this.useCarousel = false,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (useCarousel)
          CarouselSlider(
            options: CarouselOptions(
              height: 430,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 1,
            ),
            items: items.map((item) => itemBuilder(item)).toList(),
          )
        else
          ...items.map(
            (item) => Column(
              children: [itemBuilder(item), const SizedBox(height: 40)],
            ),
          ),
      ],
    );
  }
}
