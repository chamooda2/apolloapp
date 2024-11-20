import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants.dart';
import '../widgets/text_input_field.dart';

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

  String _selectedRole = 'Nutritionist'; // Default role selection
  IconData _roleIcon = Icons.health_and_safety; // Default icon
  bool _isOtpSent = false; // Tracks if OTP has been sent

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  // Update role icon dynamically
  void _updateRoleIcon(String role) {
    setState(() {
      _selectedRole = role;
      _roleIcon =
          role == 'Nutritionist' ? Icons.health_and_safety : Icons.restaurant;
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
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Phone number verified successfully!')),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
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
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number verified successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
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
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(_roleIcon),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  items: ['Nutritionist', 'FNB Department']
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
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
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(_isOtpSent ? 'Verify OTP' : 'Send OTP'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle register logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigate to Login page
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
