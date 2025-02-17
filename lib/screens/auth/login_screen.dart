



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'auth_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _authService = AuthService();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendOtp() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
      
//       await _authService.verifyPhone(
//         phoneNumber: _phoneController.text,
//         onCodeSent: (String verificationId) {
//           setState(() => _isLoading = false);
//           Navigator.pushNamed(
//             context,
//             '/otp',
//             arguments: {
//               'verificationId': verificationId,
//               'phoneNumber': _phoneController.text,
//             },
//           );
//         },
//         onError: (String error) {
//           setState(() => _isLoading = false);
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(error)),
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 48),
//                 const Text(
//                   'Enter your mobile number',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 TextFormField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     prefixText: '+91 ',
//                     hintText: 'Phone number',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your phone number';
//                     }
//                     if (value.length != 10) {
//                       return 'Phone number must be 10 digits';
//                     }
//                     if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                       return 'Please enter valid phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _sendOtp,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text('Continue'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _proceedToProfile() async {
  if (_formKey.currentState!.validate()) {
    final phoneNumber = _phoneController.text;
    Navigator.pushReplacementNamed(
      context,
      '/profile',
      arguments: {'phoneNumber': '+91$phoneNumber'},
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                const Text(
                  'Enter your mobile number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixText: '+91 ',
                    hintText: 'Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _proceedToProfile,

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
