// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '/screens/home_screen.dart';
// import '/screens/auth/login_screen.dart';
// import '/screens/bookings/bookings_screen.dart';
// import '/screens/profile/profile_screen.dart';
// import '/screens/service_details_screen.dart';
// import '/screens/help/help_screen.dart';
// import '/screens/auth/otp_verify.dart';
// import '/screens/auth/signup_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Urban Company',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           primary: Colors.deepPurple,
//           secondary: Colors.orangeAccent,
//         ),
//         scaffoldBackgroundColor: Colors.grey[50],
//         fontFamily: 'Poppins',
//         textTheme: GoogleFonts.poppinsTextTheme(),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepPurple, // Button background color
//             foregroundColor: Colors.white, // Text color
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//       darkTheme: ThemeData.dark().copyWith(
//         colorScheme: ColorScheme.dark(
//           primary: Colors.deepPurple,
//           secondary: Colors.orangeAccent,
//         ),
//         cardTheme: CardTheme(
//           color: Colors.grey[900],
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         textTheme: GoogleFonts.poppinsTextTheme().apply(
//           bodyColor: Colors.white, // Default text color
//           displayColor: Colors.white, // Headings and titles
//         ),
//       ),
//       // themeMode: ThemeMode.system,
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginScreen(),
//         '/signup': (context) => const SignupScreen(),
//         '/otp': (context) {
//           final args = ModalRoute.of(context)?.settings.arguments;

//           if (args is Map<String, String>) {
//             return OtpVerificationScreen(
//               phoneNumber: args['phoneNumber'] ?? '',
//               verificationId: args['verificationId'] ?? '',
//             );
//           } else {
//             return const Scaffold(
//               body: Center(child: Text('Invalid arguments for OTP screen')),
//             );
//           }
//         },
//         '/home': (context) => const HomeScreen(),
//         '/bookings': (context) => const BookingsScreen(),
//         '/help': (context) => const HelpScreen(),
//         '/profile': (context) => const ProfileScreen(),
//         '/service-details': (context) => ServiceDetailsScreen(),
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/screens/home_screen.dart';
// import '/screens/auth/login_screen.dart';
// import '/screens/bookings/bookings_screen.dart';
// import '/screens/profile/profile_screen.dart';
// import '/screens/service_details_screen.dart';
// import '/screens/help/help_screen.dart';
// import '/screens/auth/otp_verify.dart';
// import '/screens/auth/signup_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Urban Company',
//       theme: ThemeData(
//         colorScheme: ColorScheme.light(
//           primary: Colors.deepPurple,
//           secondary: Colors.orangeAccent,
//         ),
//         scaffoldBackgroundColor: Colors.grey[50],
//         fontFamily: 'Poppins',
//         textTheme: GoogleFonts.poppinsTextTheme(),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.deepPurple[50],
//           elevation: 2,
//           iconTheme: const IconThemeData(color: Colors.deepPurple),
//           titleTextStyle: GoogleFonts.poppins(
//             color: Colors.deepPurple,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepPurple, // Button background color
//             foregroundColor: Colors.white, // Text color
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginScreen(),
//         '/signup': (context) => const SignupScreen(),
//         '/otp': (context) {
//           final args = ModalRoute.of(context)?.settings.arguments;

//           if (args is Map<String, String>) {
//             return OtpVerificationScreen(
//               phoneNumber: args['phoneNumber'] ?? '',
//               verificationId: args['verificationId'] ?? '',
//             );
//           } else {
//             return const Scaffold(
//               body: Center(child: Text('Invalid arguments for OTP screen')),
//             );
//           }
//         },
//         '/home': (context) => const HomeScreen(),
//         '/bookings': (context) => const BookingsScreen(),
//         '/help': (context) => const HelpScreen(),
//         '/profile': (context) => const ProfileScreen(),
//         '/service-details': (context) => ServiceDetailsScreen(),
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/home_screen.dart';
import '/screens/auth/login_screen.dart';
import '/screens/bookings/bookings_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/service_details_screen.dart';
import '/screens/help/help_screen.dart';
import '/screens/auth/otp_verify.dart';
import '/screens/auth/signup_screen.dart';

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
            backgroundColor: Colors.deepPurple, // Button background color
            foregroundColor: Colors.white, // Text color
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: AuthWrapper(), // Use AuthWrapper to handle authentication state
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
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking auth state
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // If the user is logged in, navigate to the home screen
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          // If the user is not logged in, navigate to the login screen
          return const LoginScreen();
        }
      },
    );
  }
}