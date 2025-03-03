import 'package:flutter/material.dart';
import '../screens/widgets/service_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    void _subscribeToPlan(
        BuildContext context, Map<String, dynamic> plan) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to subscribe.')),
        );
        return;
      }

      // Calculate start and end dates
      final startDate = DateTime.now();
      final endDate = startDate.add(Duration(days: plan['duration']));

      // Add subscription to Firestore
      await FirebaseFirestore.instance.collection('user_subscriptions').add({
        'userId': user.uid,
        'planId': plan['id'],
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': 'active',
        'nextDelivery':
            startDate.add(Duration(days: plan['duration'])).toIso8601String(),
        'serviceDetails': {
          'title': plan['title'],
          'price': plan['price'],
          'image':
              'assets/images/services/${plan['category'].toLowerCase()}_banner.jpeg',
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subscription successful!')),
      );
      Navigator.pop(context); // Close the modal
    }

    void _showPlanDetails(BuildContext context, Map<String, dynamic> plan) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allow the modal to expand
        builder: (context) {
          return Container(
            height:
                MediaQuery.of(context).size.height * 0.7, // 70% of the screen
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Close the details modal
                    },
                  ),
                  const SizedBox(height: 16),
                  // Plan details
                  Image.asset(
                    'assets/images/services/${plan['category'].toLowerCase()}_banner.jpeg',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    plan['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan['description'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        '₹${plan['price']}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        '${plan['duration']} days',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.discount, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        '${plan['discount']}% discount',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _subscribeToPlan(
                              context, plan); // Subscribe to the plan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget _buildPlanList(
        BuildContext context, List<QueryDocumentSnapshot> plans) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index].data() as Map<String, dynamic>;
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _showPlanDetails(
                    context, plan); // Show plan details in a new modal
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          '₹${plan['price']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '${plan['duration']} days',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.discount,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          '${plan['discount']}% discount',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _subscribeToPlan(
                              context, plan); // Subscribe to the plan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Widget _buildPlanDetails(
        BuildContext context, Map<String, dynamic> plan, Function onBack) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                onBack(); // Go back to the list
              },
            ),
            const SizedBox(height: 16),
            // Plan details
            Image.asset(
              'assets/images/services/${plan['category'].toLowerCase()}_banner.jpeg',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              plan['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plan['description'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  '₹${plan['price']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '${plan['duration']} days',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.discount, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  '${plan['discount']}% discount',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _subscribeToPlan(context, plan);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Subscribe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    void _showSubscriptionPlans(BuildContext context, String category) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allow the modal to expand
        builder: (context) {
          return Container(
            height:
                MediaQuery.of(context).size.height * 0.5, // Half of the screen
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('subscription_plans')
                  .where('category', isEqualTo: category)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No subscription plans available.'));
                } else {
                  final plans = snapshot.data!.docs;
                  return _buildPlanList(context, plans);
                }
              },
            ),
          );
        },
      );
    }

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showSubscriptionPlans(context, selectedCategory);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Subscribe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
