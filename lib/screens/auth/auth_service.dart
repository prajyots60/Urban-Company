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
      }

      return true;
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

  Future<void> updateUserProfile({
    required String phone,
    required String name,
    required String email,
    required String address,
  }) async {
    try {
      await _firestore.collection('users').doc(phone).set({
        'phone': phone,
        'name': name,
        'email': email,
        'address': address,
      }, SetOptions(merge: true)); // Merge ensures updates don't overwrite existing fields
    } catch (e) {
      throw Exception('Error saving profile: $e');
    }
  }

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


  Future<void> signupUser({required String phoneNumber, required String name, required String email}) async {
    try {
      // Create new user in Firestore
      await _firestore.collection('users').doc(phoneNumber).set({
        'name': name,
        'email': email,
        'phone': phoneNumber,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Check if user profile exists based on phone number
  Future<Map<String, dynamic>?> getUserProfileByPhoneNumber(String phoneNumber) async {
    try {
      // Normalize phone number (strip country code if necessary)
      String normalizedPhone = phoneNumber.replaceFirst('+91', '');  // Adjust if needed for your app

      // Query Firestore to find the user document by phone number
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(normalizedPhone).get();

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
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
