import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  final String name;
  final String email;
  final String profession;
  final String location;

  const EditProfilePage({
    super.key,
    required this.userId,
    required this.name,
    required this.email,
    required this.profession,
    required this.location,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController professionController;
  late TextEditingController locationController;
  late TextEditingController phoneController;

  String? gender; // Variable to store selected gender
  String? fcmToken; // Variable to store FCM token
  String? nameError, emailError, professionError, phoneError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    professionController = TextEditingController(text: widget.profession);
    locationController = TextEditingController(text: widget.location);
    phoneController = TextEditingController(); // Empty initially

    // Fetch the FCM token on initialization
    _fetchFcmToken();
  }

  Future<void> _fetchFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        fcmToken = token; // Store the fetched token
      });
    } catch (e) {
      print('Error fetching FCM token: $e');
    }
  }

  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      nameError = nameController.text.isEmpty ||
              !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(nameController.text)
          ? "Name must contain letters, numbers, or underscores only"
          : null;

      emailError = emailController.text.isEmpty ||
              !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                  .hasMatch(emailController.text)
          ? "Enter a valid email address"
          : null;

      professionError = professionController.text.isEmpty
          ? "Profession cannot be empty"
          : null;

      phoneError = phoneController.text.isEmpty ||
              !RegExp(r'^\d{10}$').hasMatch(phoneController.text)
          ? "Phone number must be exactly 10 digits"
          : null;

      if (nameError != null ||
          emailError != null ||
          professionError != null ||
          phoneError != null) {
        isValid = false;
      }
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: 'Name',
              controller: nameController,
              errorText: nameError,
            ),
            const SizedBox(height: 10.0),
            _buildTextField(
              label: 'Email',
              controller: emailController,
              errorText: emailError,
            ),
            const SizedBox(height: 10.0),
            _buildTextField(
              label: 'Profession',
              controller: professionController,
              errorText: professionError,
            ),
            const SizedBox(height: 10.0),
            _buildTextField(
              label: 'Location',
              controller: locationController,
            ),
            const SizedBox(height: 10.0),
            _buildPhoneField(),
            const SizedBox(height: 10.0),
            _buildGenderDropdown(),
            const SizedBox(height: 10.0),
            _buildFCMTokenDisplay(),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
        ),
        if (errorText != null) const SizedBox(height: 5.0),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Row(
      children: [
        const Text('+91', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            label: 'Phone Number',
            controller: phoneController,
            errorText: phoneError,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: gender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(),
      ),
      items: ['Male', 'Female', 'Other']
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          gender = value;
        });
      },
    );
  }

  Widget _buildFCMTokenDisplay() {
    return TextField(
      controller:
          TextEditingController(text: fcmToken ?? "Fetching FCM token..."),
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'FCM Token',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_validateInputs()) return;

    try {
      if (fcmToken == null) {
        throw Exception("FCM token is not available. Please try again.");
      }

      // Update profile data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'profession': professionController.text.trim(),
        'location': locationController.text.trim(),
        'phone': '+91${phoneController.text.trim()}',
        'gender': gender,
        'fcmToken': fcmToken,
      });

      // Navigate back with updated data
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }
}
