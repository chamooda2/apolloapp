// lib/screens/signup.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutritrack/models/user_model.dart';
import 'package:nutritrack/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutritrack/models/role.dart'; // Import the shared Role enum

import '../../../../constants.dart';
import '../../widgets/text_input_field.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  Role _selectedRole = Role.Nutritionist; // Default role selection
  IconData _roleIcon = Icons.health_and_safety; // Default icon
  bool _isOtpSent = false; // Tracks if OTP has been sent
  bool _isOtpVerified = false; // Tracks if OTP has been successfully verified

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  // Update role icon dynamically
  void _updateRoleIcon(Role role) {
    setState(() {
      _selectedRole = role;
      _roleIcon = role == Role.Nutritionist
          ? Icons.health_and_safety
          : Icons.restaurant;
    });
  }

  // Send OTP
  void _sendOtp() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneController.text}', // Add country code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically verify and sign in
          await _auth.signInWithCredential(credential);
          setState(() {
            _isOtpSent = false;
            _isOtpVerified = true; // OTP is verified automatically
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phone number verified successfully!')),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isOtpSent = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent successfully!')),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Verify OTP
  void _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);
      setState(() {
        _isOtpVerified = true; // OTP verified after manual entry
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number verified successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
      );
    }
  }

  // Register user in Firestore
  void _registerUser() async {
    if (!_isOtpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please verify your phone number first!')),
      );
      return;
    }
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Create the UserModel instance
        UserModel newUser = UserModel(
          name: _nameController.text,
          role: _selectedRole,
          empID: _employeeIdController.text,
          phoneNumber: _phoneController.text,
          createdAt: DateTime.now(),
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(newUser.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );

        // Navigate to Login Screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Nutri',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.orange,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(
                      text: 'Track',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.blue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _nameController,
                  labelText: 'Name',
                  icon: Icons.person,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  icon: Icons.phone,
                ),
              ),
              if (_isOtpSent)
                Container(
                  padding: const EdgeInsets.only(top: 15.0),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    controller: _otpController,
                    labelText: 'Enter OTP',
                    icon: Icons.security,
                  ),
                ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField<Role>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(_roleIcon),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  items: Role.values
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role.toString().split('.').last),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateRoleIcon(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _employeeIdController,
                  labelText: 'Employee ID',
                  icon: Icons.badge,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isOtpVerified
                        ? _registerUser
                        : null, // Disable before OTP verification
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          _isOtpVerified ? Colors.blue : Colors.grey,
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
