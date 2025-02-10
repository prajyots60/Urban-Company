import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({super.key});

  @override

  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'assets/images/banners/banner2.webp',
      'assets/images/banners/banner1.webp',
      'assets/images/banners/banner3.webp',
    ];
   
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0, // Adjusted height for a better banner display
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0, // This ensures the image takes full width
        aspectRatio: 16 / 9, // This ensures the image has a 16:9 aspect ratio
      ),
      items: bannerImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width:
                  MediaQuery.of(context).size.width, // Full width of the device
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit
                      .cover, // This will ensure the image covers the entire container
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
