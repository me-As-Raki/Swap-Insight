import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swapapp/pages/forgot_password.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _rememberMe = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: _phoneController.text.trim())
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Phone number not registered.');
      }

      String email = querySnapshot.docs.first.get('email');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  Future<void> _signUp() async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      String fakeEmail = "${_phoneController.text.trim()}@example.com";

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': fakeEmail,
          'phone': _phoneController.text.trim(),
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-Up failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _currentPageIndex == 0
                    ? "Login to continue exploring amazing features"
                    : "Join us and start your journey!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton('Login', 0),
                  _buildTabButton('Sign Up', 1),
                ],
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 400,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  children: [
                    _buildLoginForm(),
                    _buildSignUpForm(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPageIndex == index
                          ? const Color(0xFF0071bc)
                          : Colors.grey,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _currentPageIndex == index
                ? const Color(0xFF0071bc)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: _currentPageIndex == index ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTextField(_phoneController, 'Phone Number', Icons.phone),
        const SizedBox(height: 20.0),
        _buildPasswordTextField(_passwordController, 'Password', Icons.lock),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
                const Text("Remember Me",
                    style: TextStyle(color: Colors.black87)),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()),
                );
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Color(0xFFE53935), fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        _buildButton('Login', isSignUp: false),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildTextField(_phoneController, 'Phone Number', Icons.phone),
        const SizedBox(height: 20.0),
        _buildPasswordTextField(_passwordController, 'Password', Icons.lock),
        const SizedBox(height: 20.0),
        _buildPasswordTextField(
            _confirmPasswordController, 'Confirm Password', Icons.lock_outline),
        const SizedBox(height: 20.0),
        _buildButton('Sign Up', isSignUp: true),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_passwordVisible : false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildPasswordTextField(
      TextEditingController controller, String hintText, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: controller == _passwordController
          ? !_passwordVisible
          : !_confirmPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            controller == _passwordController
                ? (_passwordVisible ? Icons.visibility : Icons.visibility_off)
                : (_confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              if (controller == _passwordController) {
                _passwordVisible = !_passwordVisible;
              } else {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              }
            });
          },
        ),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildButton(String text, {required bool isSignUp}) {
    return ElevatedButton(
      onPressed: isSignUp ? _signUp : _login,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        backgroundColor: const Color(0xFF0071bc),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
