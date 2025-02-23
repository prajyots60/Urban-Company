import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookings & Plans'),
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
            _buildUpcomingBookings(user?.uid),
            _buildBookingHistory(user?.uid),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings(String? userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: userId != null
          ? FirebaseFirestore.instance
              .collection('bookings')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'Upcoming')
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final bookings = snapshot.data!.docs;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index].data() as Map<String, dynamic>;
            return _buildBookingItem(booking, context);
          },
        );
      },
    );
  }

  Widget _buildBookingHistory(String? userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: userId != null
          ? FirebaseFirestore.instance
              .collection('bookings')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'Completed')
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final bookings = snapshot.data!.docs;
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index].data() as Map<String, dynamic>;
            return _buildBookingItem(booking, context);
          },
        );
      },
    );
  }

  Widget _buildBookingItem(Map<String, dynamic> booking, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.calendar_today, color: Colors.purple),
        title: Text(
          booking['serviceTitle'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Date: ${booking['date'].toDate()}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Price: ${booking['price']}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showBookingDetails(context, booking);
        },
      ),
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ), builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.drag_handle, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Service', booking['serviceTitle']),
              const Divider(),
              _buildDetailRow('Date', booking['date'].toDate().toString()),
              const Divider(),
              _buildDetailRow('Price', booking['price']),
              const Divider(),
              _buildDetailRow('Status', booking['status']),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BookingsScreen extends StatelessWidget {
//   const BookingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Bookings & plans'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'UPCOMING'),
//               Tab(text: 'HISTORY'),
//             ],
//             labelColor: Colors.purple,
//             unselectedLabelColor: Colors.grey,
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildUpcomingBookings(user?.uid),
//             _buildBookingHistory(user?.uid),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUpcomingBookings(String? userId) {
//   return StreamBuilder<QuerySnapshot>(
//     stream: userId != null
//         ? FirebaseFirestore.instance
//             .collection('bookings')
//             .where('userId', isEqualTo: userId)
//             .where('status', isEqualTo: 'Upcoming')
//             .snapshots()
//         : null,
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return const Center(child: CircularProgressIndicator());
//       }
//       final bookings = snapshot.data!.docs;
//       return ListView.builder(
//         itemCount: bookings.length,
//         itemBuilder: (context, index) {
//           final booking = bookings[index].data() as Map<String, dynamic>;
//           return Card(
//             margin: const EdgeInsets.all(8),
//             child: ListTile(
//               title: Text(booking['serviceTitle']),
//               subtitle: Text('Date: ${booking['date'].toDate()}'),
//               trailing: Text(booking['price']),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

//   Widget _buildBookingHistory(String? userId) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: userId != null
//           ? FirebaseFirestore.instance
//               .collection('bookings')
//               .where('userId', isEqualTo: userId)
//               .where('status', isEqualTo: 'Completed')
//               .snapshots()
//           : null,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final bookings = snapshot.data!.docs;
//         return ListView.builder(
//           itemCount: bookings.length,
//           itemBuilder: (context, index) {
//             final booking = bookings[index].data() as Map<String, dynamic>;
//             return Card(
//               margin: const EdgeInsets.all(8),
//               child: ListTile(
//                 title: Text(booking['serviceTitle']),
//                 subtitle: Text('Date: ${booking['date'].toDate()}'),
//                 trailing: Text(booking['price']),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
