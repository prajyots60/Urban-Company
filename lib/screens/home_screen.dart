import 'package:flutter/material.dart';
import './widgets/service_category.dart';
import './widgets/banner_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Company'),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Slider at the top
                  const BannerSlider(),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for services...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Services heading
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Grid of service categories
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
                          image:
                              'assets/images/categories/electrician_plumber.png',
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
          );
        },
      ),

      // Bottom Navigation Bar
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




