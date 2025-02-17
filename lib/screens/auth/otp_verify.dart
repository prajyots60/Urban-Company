import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<String> _otpValues = List.filled(6, '');
  String? _verificationId;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
  }

  void _validateOtp() async {
    final otp = _otpValues.join();

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits of the OTP')),
      );
      return;
    }

   try {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: _verificationId!,
    smsCode: otp,
  );

  // Sign in with the credential
  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  final user = userCredential.user;

  if (user != null) {
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    throw Exception('User object is null after sign-in');
  }
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error verifying OTP: $e')),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            const Text(
              'Enter verification code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We have sent you a 6-digit OTP on ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 50,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        _otpValues[index] = value;
                        if (index < 5) FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        _otpValues[index] = '';
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _validateOtp,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}


// otp_verification_screen.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// // User detail model for type-safe data handling
// class UserDetail {
//   final String uid;
//   final String? phoneNumber;
//   final String? email;

//   UserDetail({
//     required this.uid,
//     this.phoneNumber,
//     this.email,
//   });

//   factory UserDetail.fromMap(Map<String, dynamic> map) {
//     return UserDetail(
//       uid: map['uid'] as String,
//       phoneNumber: map['phoneNumber'] as String?,
//       email: map['email'] as String?,
//     );
//   }

//   Map<String, dynamic> toMap() => {
//     'uid': uid,
//     'phoneNumber': phoneNumber,
//     'email': email,
//   };
// }

// class OtpVerificationScreen extends StatefulWidget {
//   const OtpVerificationScreen({super.key});

//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final List<TextEditingController> _controllers =
//       List.generate(6, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
//   bool _isLoading = false;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     // Add listeners to focus nodes
//     for (var i = 0; i < _focusNodes.length; i++) {
//       _focusNodes[i].addListener(() => _onFocusChange(i));
//     }
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onFocusChange(int index) {
//     if (_focusNodes[index].hasFocus && _controllers[index].text.isNotEmpty) {
//       if (index < 5) {
//         _focusNodes[index + 1].requestFocus();
//       } else {
//         _focusNodes[index].unfocus();
//       }
//     }
//   }

//   Future<void> _verifyOtp(Map<String, dynamic> args) async {
//     final otp = _controllers.map((c) => c.text).join();
//     if (otp.length != 6) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter complete OTP'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Create a PhoneAuthCredential with the code
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: args['verificationId'] as String,
//         smsCode: otp,
//       );

//       // Sign in the user with the credential
//       final UserCredential userCredential = 
//           await _auth.signInWithCredential(credential);
      
//       // Create user detail object
//       final UserDetail userDetail = UserDetail(
//         uid: userCredential.user?.uid ?? '',
//         phoneNumber: userCredential.user?.phoneNumber,
//         email: userCredential.user?.email,
//       );

//       if (!mounted) return;
      
//       // Navigate to profile screen with user details
//       Navigator.pushReplacementNamed(
//         context, 
//         '/profile',
//         arguments: userDetail.toMap(),
//       );
//     } on FirebaseAuthException catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(_getErrorMessage(e)),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   String _getErrorMessage(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'invalid-verification-code':
//         return 'Invalid OTP. Please try again.';
//       case 'too-many-requests':
//         return 'Too many attempts. Please try again later.';
//       case 'session-expired':
//         return 'OTP session expired. Please request a new OTP.';
//       default:
//         return e.message ?? 'Verification failed';
//     }
//   }

//   Widget _buildOtpField(int index) {
//     return SizedBox(
//       width: 50,
//       child: TextFormField(
//         controller: _controllers[index],
//         focusNode: _focusNodes[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         style: const TextStyle(fontSize: 24),
//         decoration: InputDecoration(
//           counterText: "",
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Colors.blue, width: 2),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.length == 1 && index < 5) {
//             _focusNodes[index + 1].requestFocus();
//           } else if (value.isEmpty && index > 0) {
//             _focusNodes[index - 1].requestFocus();
//           }
//         },
//         enableIMEPersonalizedLearning: false,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Verify OTP'),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 48),
//               const Text(
//                 'Enter verification code',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'We have sent you a 6 digit OTP on ${args['phoneNumber'] ?? ''}',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.grey),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: List.generate(6, (index) => _buildOtpField(index)),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : () => _verifyOtp(args),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : const Text(
//                         'Verify OTP',
//                         style: TextStyle(fontSize: 16),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }