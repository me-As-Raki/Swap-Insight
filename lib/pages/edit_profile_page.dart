import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  // Pass the current profile data to EditProfilePage
  final String name;
  final String email;
  final String profession;
  final String location;

  const EditProfilePage({super.key, 
    required this.name,
    required this.email,
    required this.profession,
    required this.location,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Text controllers to hold the user's input
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController professionController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with the passed values
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    professionController = TextEditingController(text: widget.profession);
    locationController = TextEditingController(text: widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to Profile page without saving
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: professionController,
              decoration: const InputDecoration(
                labelText: 'Profession',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle saving profile information
                _saveProfile();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    // Return the updated profile data to ProfilePage
    Navigator.pop(context, {
      'name': nameController.text,
      'email': emailController.text,
      'profession': professionController.text,
      'location': locationController.text,
    });
  }
}
