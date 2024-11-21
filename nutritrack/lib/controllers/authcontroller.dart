import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutritrack/models/role.dart';
import 'package:nutritrack/models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  // Register user with phone number and OTP
  Future<User?> registerWithPhone({
    required String phoneNumber,
    required String otp,
    required String name, // Dynamic name
    required Role role, // Dynamic role
    required String empID, // Dynamic empID
  }) async {
    try {
      // Create a PhoneAuthCredential with the OTP
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      // Sign the user in with the OTP
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Add dynamic user information to Firestore
        await addUserToFirestore(user, name, role, empID);
        return user;
      }
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
    return null;
  }

  // Verify OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(PhoneAuthCredential) onVerificationCompleted,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId; // Save verificationId for later use
        onCodeSent(
            verificationId); // Call the callback function passed to update UI
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // Send user data to Firestore on registration
  Future<void> addUserToFirestore(
      User user, String name, Role role, String empID) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userModel = UserModel(
        name: name,
        role: role,
        empID: empID,
        phoneNumber: user.phoneNumber!,
        createdAt: DateTime.now(),
      );

      // Add user information to Firestore
      await firestore.collection('users').doc(user.uid).set(userModel.toMap());
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }
}
