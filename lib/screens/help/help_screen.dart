import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How can we help you?'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking related actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: const Text(
                    'Book Again',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(context, '/bookings');
                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: const Text(
                    'Send Invoice',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Trigger invoice sending
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Need more help?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'I am unhappy with my booking experience',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to feedback form
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              const ExpansionTile(
                title: Text(
                  'How do I reschedule a booking?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'You can reschedule a booking by going to the Bookings section, selecting your booking, and choosing the Reschedule option.',
                      style: TextStyle(height: 1.5),
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text(
                  'What is the cancellation policy?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cancellations made within 2 hours of the booking time may be subject to a cancellation fee.',
                      style: TextStyle(height: 1.5),
                    ),
                  ),
                ],
              ),
              const ExpansionTile(
                title: Text(
                  'How can I contact customer support?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'You can contact customer support through the Get Help section in the app or by calling our support hotline.',
                      style: TextStyle(height: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Add space after all FAQs
            ],
          ),
        ),
      ),
    );
  }
}
