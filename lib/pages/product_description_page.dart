import 'package:flutter/material.dart';

class ProductDescriptionPage extends StatelessWidget {
  final String productTitle;
  final String productDescription;
  final String imageUrl;
  final String listedUsername;
  final String currentUserProductTitle;
  final String currentUserProductImage;

  const ProductDescriptionPage({
    Key? key,
    required this.productTitle,
    required this.productDescription,
    required this.imageUrl,
    required this.listedUsername,
    required this.currentUserProductTitle,
    required this.currentUserProductImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image Box
              _buildImageBox(imageUrl),
              const SizedBox(height: 20),

              // Product Info Box
              _buildInfoBox(
                title: productTitle,
                description: productDescription,
                listedUsername: listedUsername,
              ),
              const SizedBox(height: 30),

              // "Your Product Details" Section Header
              const Text(
                'Your Product Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              // Your Product Image and Info
              _buildImageBox(currentUserProductImage,
                  title: currentUserProductTitle),
              const SizedBox(height: 40),

              // Request Exchange Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Request Sent!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFF2874F0),
                  ),
                  child: const Text(
                    'Request Exchange',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget for Image Box
  Widget _buildImageBox(String imageUrl, {String? title}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300], // Placeholder color for images
              child: const Center(
                child: Text(
                  'Photo 1', // Placeholder text
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper Widget for Info Box
  Widget _buildInfoBox({
    required String title,
    required String description,
    required String listedUsername,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Listed by: $listedUsername',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
