import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swapapp/pages/category_page.dart';
import 'package:swapapp/pages/notification_page.dart';
import 'package:swapapp/pages/profile_page.dart';

class ExchangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0), // Flipkart blue color
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      AssetImage('assets/images/logo.jpg'), // App logo
                ),
                const SizedBox(width: 10),
                const Text(
                  'SwapInSight',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () {
                    // Navigate to the Notification Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {
                    // Navigate to the Profile Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSlidingImages(), // Added scrolling images here
            const SizedBox(height: 20),
            _buildCategorySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: const [
          Icon(Icons.swap_horiz, size: 30, color: Colors.blue),
          SizedBox(width: 10),
          Text(
            'Exchange Items',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidingImages() {
    final List<String> imagePaths = [
      'assets/images/image6.png', // Update these paths with your actual images
      'assets/images/image7.png',
      'assets/images/image8.png',
      'assets/images/image9.png',
      'assets/images/image10.png',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 300.0, // Same height as in the HomePage
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.9,
      ),
      items: imagePaths.map((imagePath) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Same rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'title': 'Books', 'icon': Icons.book},
      {'title': 'Electronics', 'icon': Icons.electrical_services},
      {'title': 'Furniture', 'icon': Icons.chair},
      {'title': 'Clothes', 'icon': Icons.checkroom},
      {'title': 'Toys', 'icon': Icons.toys},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        categoryTitle: category['title'],
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue,
                      child:
                          Icon(category['icon'], size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['title'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
