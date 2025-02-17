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


Future<Map<String, dynamic>?> getUserProfileByPhoneNumber(String phoneNumber) async {
    // Remove country code if present
    String normalizedPhone = phoneNumber.replaceAll(RegExp(r'^\+\d{1,3}'), ''); 

    print("🔍 Searching for phone number: $normalizedPhone");

    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('phone', isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("❌ No profile found for $normalizedPhone");
      return null;
    }

    print("✅ Profile found: ${querySnapshot.docs.first.data()}");
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
