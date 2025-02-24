import 'package:flutter/material.dart';
import 'handyman_booking_screen.dart';

class HandymanServiceScreen extends StatelessWidget {
  const HandymanServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handyman Services'),
        centerTitle: true,
        elevation: 2,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Task',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskCard(context, 'Furniture Assembly', '₹300'),
                  _buildTaskCard(context, 'Picture Hanging', '₹200'),
                  _buildTaskCard(context, 'Shelf Installation', '₹400'),
                  _buildTaskCard(context, 'TV Mounting', '₹500'),
                  _buildTaskCard(context, 'Minor Plumbing Fix', '₹350'),
                  _buildTaskCard(context, 'Minor Electrical Work', '₹400'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, String taskName, String price) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          taskName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HandymanBookingScreen(
                serviceTitle: taskName,
                price: price,
              ),
            ),
          );
        },
      ),
    );
  }
}
