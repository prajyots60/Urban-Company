import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings & plans'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'UPCOMING'),
              Tab(text: 'HISTORY'),
            ],
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          children: [
            _buildUpcomingBookings(),
            _buildBookingHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text('Booking ${index + 1}'),
            subtitle: const Text('Upcoming service details'),
            trailing: const Text('₹499'),
          ),
        );
      },
    );
  }

  Widget _buildBookingHistory() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text('Past Booking ${index + 1}'),
            subtitle: const Text('Completed'),
            trailing: const Text('₹699'),
          ),
        );
      },
    );
  }
}
