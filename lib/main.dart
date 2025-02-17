import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/home_screen.dart';
import '/screens/auth/login_screen.dart';
import '/screens/bookings/bookings_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/service_details_screen.dart';
import '/screens/help/help_screen.dart';
import '/screens/auth/otp_verify.dart'; // Ensure OTP screen is imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Company',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
       '/otp': (context) {
  final args = ModalRoute.of(context)?.settings.arguments;

  if (args is Map<String, String>) {
    return OtpVerificationScreen(
      phoneNumber: args['phoneNumber'] ?? '',
      verificationId: args['verificationId'] ?? '',
    );
  } else {
    return const Scaffold(
      body: Center(child: Text('Invalid arguments for OTP screen')),
    );
  }
},

        '/home': (context) => const HomeScreen(),
        '/bookings': (context) => const BookingsScreen(),
        '/help': (context) => const HelpScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/service-details': (context) => ServiceDetailsScreen(),
      },
    );
  }
}
