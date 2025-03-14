import 'package:flutter/material.dart';
import './widgets/service_category.dart';
import './widgets/banner_slider.dart';
import '../screens/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _authService.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/signup');
          });
          return const Scaffold(
            body: Center(child: Text('Redirecting to signup...')),
          );
        } else {
          final userProfile = snapshot.data!;
          return _buildHomeScreen(userProfile);
        }
      },
    );
  }

  Widget _buildHomeScreen(Map<String, dynamic> userProfile) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Company'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BannerSlider(),
            // Handyman Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/handyman-services');
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '✨ Handyman Services',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Quick fixes for your home!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for services...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'All Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: const EdgeInsets.all(8),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  ServiceCategory(
                    title: "Women's Salon",
                    image: 'assets/images/categories/womens_salon.png',
                    onTapCallback: () {
                      Navigator.pushNamed(
                        context,
                        '/service-details',
                        arguments: 'WSaloon',
                      );
                    },
                  ),
                  ServiceCategory(
                    title: "Men's Salon",
                    image: 'assets/images/categories/mens_salon.png',
                    onTapCallback: () {
                      Navigator.pushNamed(
                        context,
                        '/service-details',
                        arguments: 'MSaloon',
                      );
                    },
                  ),
                  ServiceCategory(
                    title: 'AC & Appliance Repair',
                    image: 'assets/images/categories/ac_appliance.png',
                    onTapCallback: () {
                      Navigator.pushNamed(
                        context,
                        '/service-details',
                        arguments: 'Repair',
                      );
                    },
                  ),
                  ServiceCategory(
                    title: 'Cleaning',
                    image: 'assets/images/categories/cleaning.png',
                    onTapCallback: () {
                      Navigator.pushNamed(
                        context,
                        '/service-details',
                        arguments: 'Cleaning',
                      );
                    },
                  ),
                  ServiceCategory(
                    title: 'Wall Painting',
                    image: 'assets/images/categories/wall_painting.png',
                    onTapCallback: () {
                      Navigator.pushNamed(
                        context,
                        '/service-details',
                        arguments: 'Wall Painting',
                      );
                    },
                  ),
                  ServiceCategory(
                    title: 'Electrician, Plumber & Carpenters',
                    image: 'assets/images/categories/electrician_plumber.png',
                    onTapCallback: () {
                      Navigator.pushNamed(
                        context,
                        '/service-details',
                        arguments: 'Repair',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/bookings');
              break;
            case 2:
              Navigator.pushNamed(context, '/help');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Get Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
