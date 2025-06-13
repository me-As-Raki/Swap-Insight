import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String _gender = "Male";
  File? _imageFile;
  String _profileImageUrl = '';
  String _userId = '';
  String _fcmToken = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Fetch user details from Firestore and FirebaseAuth
  Future<void> _fetchUserDetails() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        _userId = user.uid; // Fetch userId
        final userDoc =
            await _firestore.collection('profiles').doc(user.uid).get();

        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            _nameController.text = data?['name'] ?? '';
            _usernameController.text = data?['username'] ?? '';
            _addressController.text = data?['address'] ?? '';
            _gender = data?['gender'] ?? 'Male';
            _profileImageUrl = data?['profile_image'] ?? '';
            _emailController.text = user.email ?? 'No email';

            // Fetch and display phone number, stripping the country code if it exists
            String phoneNumber = data?['phone_number'] ?? '';
            if (phoneNumber.startsWith('+91')) {
              phoneNumber = phoneNumber.substring(3); // Remove country code
            }
            _phoneNumberController.text = phoneNumber;
          });
        } else {
          _showErrorMessage("User data not found in Firestore.");
        }
      } else {
        _showErrorMessage("No user is logged in.");
      }
    } catch (e) {
      _showErrorMessage("Error fetching user details: $e");
    }
  }

  // Save user details to Firestore
  Future<void> _saveUserDetails() async {
    try {
      // Input validations
      if (!RegExp(r'^[a-zA-Z0-9_ ]+$').hasMatch(_nameController.text.trim())) {
        _showErrorMessage(
            'Name can only contain letters, numbers, and underscores.');
        return;
      }
      if (!RegExp(r'^[a-zA-Z0-9]+$')
          .hasMatch(_usernameController.text.trim())) {
        _showErrorMessage(
            'Username must be unique and cannot contain spaces or special characters.');
        return;
      }
      if (!RegExp(r'^[0-9]{10}$')
          .hasMatch(_phoneNumberController.text.trim())) {
        _showErrorMessage('Phone number must be exactly 10 digits.');
        return;
      }

      String phoneNumber = _phoneNumberController.text.trim();
      // Ensure the phone number only contains 10 digits without the country code
      if (phoneNumber.startsWith("+91")) {
        phoneNumber = phoneNumber.substring(3); // Remove country code
      }

      if (_imageFile != null) {
        _profileImageUrl = await _uploadImageToCloudinary(_imageFile!);
      }

      final User? user = _auth.currentUser;
      if (user != null) {
        // Save FCM token to Firestore
        final fcmToken = await _fetchFCMToken();

        await _firestore.collection('profiles').doc(user.uid).set({
          'user_id': user.uid,
          'name': _nameController.text.trim(),
          'username': _usernameController.text.trim(),
          'address': _addressController.text.trim(),
          'gender': _gender,
          'profile_image': _profileImageUrl,
          'phone_number': phoneNumber,
          'fcm_token': fcmToken,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        _showErrorMessage("No user is logged in.");
      }
    } catch (e) {
      _showErrorMessage("Error saving user details: $e");
    }
  }

  // Fetch FCM token (real implementation)
  Future<String> _fetchFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        return token; // Return real FCM token
      } else {
        _showErrorMessage('FCM Token not available');
        return 'FCM Token not available';
      }
    } catch (e) {
      _showErrorMessage("Error fetching FCM token: $e");
      return 'Error fetching token';
    }
  }

  // Upload image to Cloudinary
  Future<String> _uploadImageToCloudinary(File image) async {
    try {
      const cloudName = 'dpq4c6slb';
      const uploadPreset = 'ojj9drz5';
      final uri =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);

      final file = await http.MultipartFile.fromPath('file', image.path);
      request.files.add(file);
      request.fields['upload_preset'] = uploadPreset;

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseData.body);
        return data['secure_url'];
      } else {
        _showErrorMessage('Failed to upload image to Cloudinary.');
        throw Exception('Failed to upload image to Cloudinary');
      }
    } catch (e) {
      _showErrorMessage('Error uploading image to Cloudinary: $e');
      throw Exception('Error uploading image to Cloudinary: $e');
    }
  }

  // Display error messages
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue, // Blue color maintained
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 75,
                backgroundColor:
                    Colors.blue.shade100, // Blue tint for the avatar background
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (_profileImageUrl.isNotEmpty
                        ? NetworkImage(_profileImageUrl)
                        : null) as ImageProvider?,
                child: _imageFile == null && _profileImageUrl.isEmpty
                    ? const Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField("Full Name", _nameController),
            _buildTextField("Username (Unique)", _usernameController),
            _buildTextField("Address", _addressController),
            _buildTextField("Email", _emailController, enabled: false),
            _buildTextField("Phone Number", _phoneNumberController),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _gender,
              onChanged: (String? newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
              items: const [
                DropdownMenuItem(child: Text("Male"), value: "Male"),
                DropdownMenuItem(child: Text("Female"), value: "Female"),
                DropdownMenuItem(child: Text("Other"), value: "Other"),
              ],
              decoration: InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(12),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable TextField widget
  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12),
          filled: true,
        ),
      ),
    );
  }
}
