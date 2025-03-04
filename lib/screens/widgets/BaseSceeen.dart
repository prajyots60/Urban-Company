import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/bookings/bookings_screen.dart';
import '/screens/help/help_screen.dart';
import '/screens/profile/profile_screen.dart';

class BaseScreen extends StatefulWidget {
  final int initialIndex;

  const BaseScreen({super.key, this.initialIndex = 0});

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    BookingsScreen(),
    HelpScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
