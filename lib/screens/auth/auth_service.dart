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
    // Verify and sign in with the OTP
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    final userCredential = await _auth.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) {
      throw Exception('User not found after OTP verification');
    }

    // Normalize the phone number
    String normalizedPhone = _normalizePhoneNumber(user.phoneNumber ?? '');

    // Query Firestore to check if the user exists
    final userQuery = await _firestore
        .collection('users')
        .where('phone', isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    print("Query result: ${userQuery.docs}");

    // Return true if the user needs to sign up (no profile exists)
    return userQuery.docs.isEmpty;
  } catch (e) {
    print("Error in verifyOTP: $e");
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

  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return null;
    }
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
  required String name,
  required String email,
  required String address,
}) async {
  try {
    // Get the current authenticated user
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    // Normalize phone number from the user object
    String normalizedPhone = _normalizePhoneNumber(user.phoneNumber ?? '');

    // Create new user in Firestore using UID as the document ID
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'phone': normalizedPhone,
      'name': name.trim(),
      'email': email.trim(),
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print("Error in signupUser: $e");
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

      // Update user profile in Firestore using UID as the document ID
      await _firestore.collection('users').doc(user.uid).set(
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
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Fetch profile data using UID
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print('No profile found for user ${user.uid}');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
