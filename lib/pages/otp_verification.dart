// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Ensure this is your home page import

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  const OtpVerificationPage({super.key, required this.verificationId});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _verifyOtp() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final String otp = _otpController.text.trim();
      if (otp.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the OTP')),
        );
        return;
      }

      // Create a PhoneAuthCredential with the verification ID and OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // Sign in with the credential
      await _auth.signInWithCredential(credential);
      setState(() {
        _isLoading = false;
      });

      // After successful OTP verification, navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter the OTP sent to your phone number',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'OTP',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF0071bc),
                    ),
                    child: const Text(
                      'Verify OTP',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
