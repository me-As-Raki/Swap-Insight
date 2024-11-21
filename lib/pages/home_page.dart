import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:swapapp/pages/exchange_page.dart';
import 'package:swapapp/pages/notification_page.dart';
import 'package:swapapp/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Exit the app directly when back button is pressed
        return true; // Returning true ensures the app is closed
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2874F0), // Flipkart blue color
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
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlidingImages(),
            const SizedBox(height: 20),
            _buildSectionHeading('Trending Items'),
            const SizedBox(height: 10),
            Expanded(
              child: _buildTrendingItemsLayout(),
            ),
            const SizedBox(height: 20),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // Sliding Images with added shadow effects
  Widget _buildSlidingImages() {
    final List<String> imagePaths = [
      'assets/images/image1.png', // Update these with your actual image paths
      'assets/images/image2.png',
      'assets/images/image3.png',
      'assets/images/image4.png',
      'assets/images/image5.png',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 300.0, // Adjust the height as per your design requirements
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
            borderRadius: BorderRadius.circular(12), // Slightly rounded corners
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

  // Section heading with improved style
  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Icon(Icons.trending_up, color: Colors.blue),
        ],
      ),
    );
  }

  // Trending items layout with shadow effects and refined design
  Widget _buildTrendingItemsLayout() {
    final List<String> items = List.generate(6, (index) => 'Item ${index + 1}');

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage('https://via.placeholder.com/300'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  items[0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          flex: 1,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: items.length - 1,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      items[index + 1],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Bottom buttons with more refined design and shadow effects
  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExchangePage()),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.swap_horiz, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Exchange',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to Product Info Page or handle functionality
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.comment, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Product Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
