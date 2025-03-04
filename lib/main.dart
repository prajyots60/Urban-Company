import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/screens/home_screen.dart';
import '/screens/auth/login_screen.dart';
import '/screens/bookings/bookings_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/service_details_screen.dart';
import '/screens/help/help_screen.dart';
import '/screens/auth/otp_verify.dart';
import '/screens/auth/signup_screen.dart';
import './screens/handyman_service_screen.dart';



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
      debugShowCheckedModeBanner: false,
      title: 'Urban Company',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.deepPurple,
          secondary: Colors.orangeAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Poppins',
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[50],
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.deepPurple),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.deepPurple,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, 
            foregroundColor: Colors.white, 
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: AuthWrapper(), 
      routes: {
        '/signup': (context) => const SignupScreen(),
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
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/bookings': (context) => const BookingsScreen(),
        '/help': (context) => const HelpScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/service-details': (context) => ServiceDetailsScreen(),
        '/handyman-services': (context) => HandymanServiceScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (authSnapshot.hasData) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: _checkUserProfile(authSnapshot.data!),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (profileSnapshot.hasError || !profileSnapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, '/login');
                });
                return const Scaffold(
                  body: Center(child: Text('Redirecting to login...')),
                );
              } else {
                return const HomeScreen();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  Future<Map<String, dynamic>?> _checkUserProfile(User user) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error checking user profile: $e");
      return null;
    }
  }
}