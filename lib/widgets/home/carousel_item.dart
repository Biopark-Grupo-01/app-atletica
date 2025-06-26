import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselItem extends StatelessWidget {
  final List<Map<String, String>> items;
  final bool useCarousel;
  final Widget Function(Map<String, String>) itemBuilder;
  final double? customHeight; // Altura customizada opcional

  const CarouselItem({
    super.key,
    required this.items,
    this.useCarousel = false,
    required this.itemBuilder,
    this.customHeight, // Novo parâmetro opcional
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final carouselHeight = customHeight ?? screenHeight * 0.45; // Usa altura customizada se fornecida
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (useCarousel)
          CarouselSlider(
            options: CarouselOptions(
              height: carouselHeight,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
              viewportFraction: 1.0,
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
