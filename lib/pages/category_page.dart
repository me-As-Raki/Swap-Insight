import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swapapp/pages/product_description_page.dart';
import 'package:swapapp/pages/add_item_page.dart';
import 'package:swapapp/pages/notification_page.dart';
import 'package:swapapp/pages/profile_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CategoryPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryPage({Key? key, required this.categoryTitle}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = true;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    try {
      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: widget.categoryTitle)
          .get();

      setState(() {
        _products = querySnapshot.docs
            .map((doc) {
              return {
                'title': doc['title'],
                'description': doc['description'],
                'imageUrl': doc['image_url'],
                'location': doc['location'],
                'userId': doc['user_id'],
              };
            })
            .where((product) => product['userId'] != currentUserId)
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching products: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _isSearchActive = query.isNotEmpty;
      _filteredProducts = _products
          .where((product) =>
              product['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for items...',
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: _filterProducts,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          'No results found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDescriptionPage(
                  productTitle: product['title'],
                  productDescription: product['description'],
                  imageUrl: product['imageUrl'],
                  listedUserId: product['userId'], // Pass the correct userId
                  location: product['location'], // Pass the location here
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(product['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                product['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                product['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: Text(
                product['location'],
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddProductButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddItemPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2874F0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Add Your Product',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildSlidingImages() {
    final List<String> imagePaths = [
      'assets/images/image11.png',
      'assets/images/image12.png',
      'assets/images/image13.png',
      'assets/images/image14.png',
      'assets/images/image15.png',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: imagePaths.map((imagePath) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        title: Text(widget.categoryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSlidingImages(),
                const SizedBox(height: 10),
                _buildSearchBar(),
                const SizedBox(height: 10),
                if (_isSearchActive) _buildSearchResults(),
                if (!_isSearchActive)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Start typing to search for products.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                _buildAddProductButton(),
              ],
            ),
    );
  }
}
