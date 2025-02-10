import 'package:flutter/material.dart';
import '../screens/widgets/service_card.dart';

class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory =
        ModalRoute.of(context)!.settings.arguments as String;

    final List<Map<String, String>> services = [
      {
        'title': 'Haircut + Beard grooming',
        'category': 'MSaloon',
        'duration': '45 mins',
        'price': '₹499',
        'rating': '4.8',
        'reviews': '1.2K',
        'image': 'assets/images/services/msaloon_banner.jpeg',
      },
      {
        'title': 'Women Salon & Beauty',
        'category': 'WSaloon',
        'duration': '60 mins',
        'price': '₹799',
        'rating': '4.9',
        'reviews': '2.1K',
        'image': 'assets/images/services/wsaloon_banner.jpeg',
      },
      {
        'title': 'AC Repair & Maintenance',
        'category': 'Repair',
        'duration': '90 mins',
        'price': '₹999',
        'rating': '4.7',
        'reviews': '3.5K',
        'image': 'assets/images/services/repair_banner.jpeg',
      },
      {
        'title': 'House Cleaning Services',
        'category': 'Cleaning',
        'duration': '120 mins',
        'price': '₹1499',
        'rating': '4.6',
        'reviews': '2.8K',
        'image': 'assets/images/services/cleaning_banner.jpeg',
      },
      {
        'title': 'Relaxing Body Massage',
        'category': 'Massage',
        'duration': '60 mins',
        'price': '₹1299',
        'rating': '4.9',
        'reviews': '1.8K',
        'image': 'assets/images/services/massage.jpeg',
      },
    ];

    final filteredServices = services
        .where((service) => service['category'] == selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedCategory Services'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/services/${selectedCategory.toLowerCase()}_banner.jpeg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: filteredServices.map((service) {
                      return ServiceCard(
                        title: service['title']!,
                        duration: service['duration']!,
                        price: service['price']!,
                        rating: double.parse(service['rating']!),
                        reviews: service['reviews']!,
                        image: service['image']!,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
