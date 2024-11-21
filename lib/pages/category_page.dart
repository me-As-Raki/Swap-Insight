import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:swapapp/pages/add_item_page.dart';
import 'package:swapapp/pages/notification_page.dart';
import 'package:swapapp/pages/product_description_page.dart';
import 'dart:async';

import 'package:swapapp/pages/profile_page.dart';

class CategoryPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryPage({Key? key, required this.categoryTitle}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final PageController _pageController;
  int _currentPage = 0;
  final int _totalPhotos = 5;

  final List<Map<String, String>> _allProducts = [
    {
      'title': 'Product 1',
      'description': 'This is the description for Product 1.',
      'imageUrl': 'assets/photo_1.jpg',
    },
    {
      'title': 'Product 2',
      'description': 'This is the description for Product 2.',
      'imageUrl': 'assets/photo_2.jpg',
    },
    {
      'title': 'Product 3',
      'description': 'This is the description for Product 3.',
      'imageUrl': 'assets/photo_3.jpg',
    },
  ];

  List<Map<String, String>> _filteredProducts = [];
  bool _isSearchActive = false; // Track whether search is active

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _filteredProducts = _allProducts;
    _startAutoSlide();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % _totalPhotos;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _isSearchActive = query.isNotEmpty; // Set search active flag
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
                product['title']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
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
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 10),
            if (_isSearchActive) _buildSearchResults(),
            const SizedBox(height: 20),
            _buildSlidingImages(), // Added scrolling images here
            const SizedBox(height: 20),
            _buildTrendingItems(),
            const SizedBox(height: 20),
            _buildRecentlyAddedItems(),
            // Call _buildAddProductButton here, passing context
            _buildAddProductButton(context), // Pass context explicitly
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Icon(Icons.category, size: 30, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            widget.categoryTitle,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for items...',
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: _filterProducts,
      ),
    );
  }

  Widget _buildSearchResults() {
    return _filteredProducts.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: _filteredProducts.map((product) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDescriptionPage(
                          productTitle: product['title']!,
                          productDescription: product['description']!,
                          imageUrl: product['imageUrl']!,
                          listedUsername: '',
                          currentUserProductTitle: '',
                          currentUserProductImage: '',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 3,
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                            image: AssetImage(product['imageUrl']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        product['title']!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        product['description']!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              'No results found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
  }

  Widget _buildSlidingImages() {
    final List<String> imagePaths = [
      'assets/images/image11.png', // Update these paths with your actual images
      'assets/images/image12.png',
      'assets/images/image13.png',
      'assets/images/image14.png',
      'assets/images/image15.png',
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

  Widget _buildTrendingItems() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trending Items',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index == 5) {
                  return GestureDetector(
                    onTap: () {
                      // Handle "More" button click
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.blueGrey,
                      child: const Center(
                        child: Text(
                          'More',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(
                      'Item $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyAddedItems() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recently Added',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Handle the tap action, navigate to another page or show details
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Item $index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildAddProductButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: SizedBox(
      width: double.infinity, // Make the button take full width
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the AddItemPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2874F0), // Button background color
          foregroundColor: Colors.white, // Text color
          padding: const EdgeInsets.symmetric(vertical: 14.0), // More padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          elevation: 6, // Slight shadow for a modern look
        ),
        child: const Text(
          'Add Your Product',
          style: TextStyle(
            fontSize: 18, // Larger font size for better visibility
            fontWeight: FontWeight.w600, // Semi-bold for a professional feel
            letterSpacing: 1.0, // Slight spacing for text clarity
          ),
        ),
      ),
    ),
  );
}
