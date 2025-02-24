import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to track auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification handled here
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<bool> verifyOTP({
    required String verificationId,
    required String otp,
    required Function(String) onError,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      // Check if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserProfile(userCredential.user!);
        return true; // New user, navigate to signup
      } else {
        return false; // Existing user, navigate to home
      }
    } catch (e) {
      onError(e.toString());
      return false;
    }
  }

  Future<void> _createUserProfile(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'phone': user.phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  // Future<void> updateUserProfile({
  //   required String phone,
  //   required String name,
  //   required String email,
  //   required String address,
  // }) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       throw Exception('User not logged in');
  //     }

  //     await FirebaseFirestore.instance.collection('users').doc(phone).set(
  //         {
  //           'phone': phone,
  //           'name': name,
  //           'email': email,
  //           'address': address,
  //         },
  //         SetOptions(
  //             merge:
  //                 true)); // Merge ensures updates don't overwrite existing fields
  //   } catch (e) {
  //     throw Exception('Error saving profile: $e');
  //   }
  // }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return doc.data();
        } else {
          print("User document not found");
        }
      } catch (e) {
        print("Error fetching profile: $e");
      }
    }
    return null;
  }

  // Normalize phone number
  String _normalizePhoneNumber(String phoneNumber) {
    String normalizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (normalizedPhone.length > 10) {
      normalizedPhone = normalizedPhone.substring(normalizedPhone.length - 10);
    }
    return normalizedPhone;
  }

  Future<void> signupUser({
    required String phoneNumber,
    required String name,
    required String email,
  }) async {
    try {
      // Normalize phone number
      String normalizedPhone = _normalizePhoneNumber(phoneNumber);

      // Get the current authenticated user
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      // Create new user in Firestore
      await _firestore.collection('users').doc(normalizedPhone).set({
        'uid': user.uid, // Store the authenticated user's UID
        'phone': normalizedPhone,
        'name': name.trim(),
        'email': email.trim(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required String phone,
    required String name,
    required String email,
    required String address,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Normalize phone number
      String normalizedPhone = _normalizePhoneNumber(phone);

      // Update user profile in Firestore
      await _firestore.collection('users').doc(normalizedPhone).set(
        {
          'phone': normalizedPhone,
          'name': name,
          'email': email,
          'address': address,
        },
        SetOptions(
            merge:
                true), // Merge ensures updates don't overwrite existing fields
      );
    } catch (e) {
      throw Exception('Error saving profile: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfileByPhoneNumber(
      String phoneNumber) async {
    try {
      // Normalize phone number
      String normalizedPhone = _normalizePhoneNumber(phoneNumber);

      // Query Firestore to find the user document by phone number
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(normalizedPhone).get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print('No profile found for $normalizedPhone');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Future<void> signupUser(
  //     {required String phoneNumber,
  //     required String name,
  //     required String email}) async {
  //   try {
  //     // Normalize phone number
  //     String normalizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  //     if (normalizedPhone.length > 10) {
  //       normalizedPhone =
  //           normalizedPhone.substring(normalizedPhone.length - 10);
  //     }

  //     // Get the current authenticated user
  //     final user = _auth.currentUser;
  //     if (user == null) {
  //       throw Exception('User is not authenticated');
  //     }

  //     // Create new user in Firestore
  //     await _firestore.collection('users').doc(normalizedPhone).set({
  //       'uid': user.uid, // Store the authenticated user's UID
  //       'phone': normalizedPhone,
  //       'name': name.trim(),
  //       'email': email.trim(),
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Check if user profile exists based on phone number
  // Future<Map<String, dynamic>?> getUserProfileByPhoneNumber(
  //     String phoneNumber) async {
  //   try {
  //     print(
  //         'Fetching user profile for phone number: $phoneNumber'); // Debug log
  //     // Normalize phone number: remove all non-numeric characters and keep the last 10 digits
  //     String normalizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  //     if (normalizedPhone.length > 10) {
  //       normalizedPhone =
  //           normalizedPhone.substring(normalizedPhone.length - 10);
  //     }
  //     print('Normalized phone number: $normalizedPhone'); // Debug log

  //     // Query Firestore to find the user document by phone number
  //     DocumentSnapshot snapshot =
  //         await _firestore.collection('users').doc(normalizedPhone).get();
  //     print('Firestore query result: ${snapshot.exists}'); // Debug log

  //     if (snapshot.exists) {
  //       return snapshot.data() as Map<String, dynamic>;
  //     } else {
  //       print('No profile found for $normalizedPhone'); // Debug log
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching user profile: $e'); // Debug log
  //     return null;
  //   }
  // }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
