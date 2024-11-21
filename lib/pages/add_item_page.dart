import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _manualLocationController =
      TextEditingController();
  String? _selectedCategory;
  String? _selectedSubcategory;
  File? _selectedImage;
  String? _currentLocation;

  // Function to handle image selection
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery); // From gallery

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo uploaded successfully!')),
      );
    }
  }

  // Function to fetch the user's location
  Future<void> _fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Location services are disabled. Please enable them.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Location permissions are permanently denied. Please allow them in settings.')),
      );
      return;
    }

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert to a readable address
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentLocation = "${place.locality}, ${place.administrativeArea}";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location fetched successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle form submission
      String title = _titleController.text;
      String category = _selectedCategory ?? "Uncategorized";
      String subcategory = _selectedSubcategory ?? "No Subcategory";
      String location =
          _currentLocation ?? _manualLocationController.text.trim();

      // Simulate saving to a database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Product Added: $title\nCategory: $category\nSubcategory: $subcategory\nLocation: $location'),
        ),
      );

      // Reset form
      _titleController.clear();
      _descriptionController.clear();
      _manualLocationController.clear();
      setState(() {
        _selectedImage = null;
        _selectedCategory = null;
        _selectedSubcategory = null;
        _currentLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Product'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Product Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Product Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Electronics', 'Clothing', 'Books', 'Others']
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Subcategory Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedSubcategory,
                  decoration: const InputDecoration(
                    labelText: 'Subcategory',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Mobile', 'Laptop', 'Novel', 'Shirt'].map((subcategory) {
                    return DropdownMenuItem(
                      value: subcategory,
                      child: Text(subcategory),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubcategory = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap to Add Image',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Location Picker
                ElevatedButton.icon(
                  onPressed: _fetchLocation,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Use My Current Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),

                // Manual Location Input
                TextFormField(
                  controller: _manualLocationController,
                  decoration: InputDecoration(
                    labelText: 'Or Enter Location Manually',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Display Current Location
                if (_currentLocation != null)
                  Text(
                    'Current Location: $_currentLocation',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                const SizedBox(height: 20),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Add Product',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
