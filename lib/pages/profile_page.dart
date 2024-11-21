import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Import your login/signup page for navigation

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Logout method
  Future<void> _logout() async {
    try {
      await _auth.signOut(); // Sign out from Firebase
      // Navigate back to the Login/SignUp page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser; // Get current user

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF0071bc),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Call logout on button press
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (user != null) ...[
              // Profile Info Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          user.photoURL ??
                              'https://www.example.com/default-profile-pic.png', // Default image if no photoURL
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Name: ${user.displayName ?? 'No Name'}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${user.email ?? 'No Email'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'UID: ${user.uid}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Logout Button
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFE53935), // Red color for logout
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.redAccent,
                  elevation: 10,
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ] else ...[
              const Text(
                'No user is logged in.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
