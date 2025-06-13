import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDescriptionPage extends StatefulWidget {
  final String productTitle;
  final String productDescription;
  final String imageUrl;
  final String location;
  final String listedUserId;

  const ProductDescriptionPage({
    Key? key,
    required this.productTitle,
    required this.productDescription,
    required this.imageUrl,
    required this.location,
    required this.listedUserId,
  }) : super(key: key);

  @override
  _ProductDescriptionPageState createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  bool _isProductsLoading = true;
  bool _isListedUserDetailsLoading = true;
  bool _isUserDetailsLoading = true;

  Map<String, dynamic> _listedUserDetails = {};
  Map<String, dynamic> _userDetails = {};
  List<Map<String, dynamic>> _userProducts = [];
  String? _selectedProduct;
  Map<String, dynamic>? _selectedProductDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserProducts();
    _fetchListedUserDetails();
  }

  Future<void> _fetchListedUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(widget.listedUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _listedUserDetails = userDoc.data() as Map<String, dynamic>;
          _isListedUserDetailsLoading = false;
        });
      } else {
        setState(() {
          _isListedUserDetailsLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching listed user details: $error");
      setState(() {
        _isListedUserDetailsLoading = false;
      });
    }
  }

  Future<void> _fetchUserProducts() async {
    try {
      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('user_id', isEqualTo: currentUserId)
          .get();

      setState(() {
        _userProducts = querySnapshot.docs.map((doc) {
          return {
            'title': doc['title'],
            'description': doc['description'],
            'imageUrl': doc['image_url'],
            'location': doc['location'],
            'userId': doc['user_id'],
            'productId': doc.id,
          };
        }).toList();
        _isProductsLoading = false;
      });
    } catch (error) {
      print("Error fetching user products: $error");
      setState(() {
        _isProductsLoading = false;
      });
    }
  }

  Future<void> _fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _userDetails = userDoc.data() as Map<String, dynamic>;
          _isUserDetailsLoading = false;
        });
      } else {
        print("User not found");
        setState(() {
          _isUserDetailsLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching user details: $error");
      setState(() {
        _isUserDetailsLoading = false;
      });
    }
  }

  void _onProductSelected(String? productId) {
    setState(() {
      _selectedProduct = productId;
      _selectedProductDetails = _userProducts.firstWhere(
        (product) => product['productId'] == productId,
        orElse: () => {},
      );
    });

    if (_selectedProductDetails != null) {
      _fetchUserDetails(_selectedProductDetails!['userId']);
    }
  }

  Widget _buildProductDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: DropdownButton<String>(
        value: _selectedProduct,
        hint: const Text(
          'Choose your product to exchange',
          style: TextStyle(fontSize: 16),
        ),
        isExpanded: true,
        onChanged: _onProductSelected,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        underline: const SizedBox(),
        items: _userProducts.map<DropdownMenuItem<String>>((product) {
          return DropdownMenuItem<String>(
            value: product['productId'],
            child: Text(product['title']),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedProductDetails() {
    if (_selectedProductDetails == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Selected Product Details:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(_selectedProductDetails!['imageUrl']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _selectedProductDetails!['title'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _selectedProductDetails!['description'],
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Text(
          'Location: ${_selectedProductDetails!['location']}',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        if (_userDetails.isNotEmpty) ...[
          const Text(
            'Listed By:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _userDetails['name'] ?? 'Unknown',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          const Text(
            'Contact:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _userDetails['email'] ?? 'No contact information provided',
            style: const TextStyle(fontSize: 14),
          ),
        ] else
          const Text(
            'No user details found for this product.',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        title: Text(widget.productTitle),
      ),
      body: _isProductsLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Details Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(widget.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Product Title
                          Text(
                            widget.productTitle,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Product Description
                          Text(
                            widget.productDescription,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Product Location
                          Text(
                            'Location: ${widget.location}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Listed User Details
                          if (!_isListedUserDetailsLoading &&
                              _listedUserDetails.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Listed By:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _listedUserDetails['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Contact: ${_listedUserDetails['email'] ?? 'No email provided'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User's Product Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Product Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildProductDropdown(),
                          _buildSelectedProductDetails(),
                          const SizedBox(height: 20),
                          // Request Exchange Button
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: const Color(0xFF2874F0),
                                elevation: 3,
                              ),
                              onPressed: () {
                                if (_selectedProduct != null) {
                                  print(
                                      'Requesting exchange for $_selectedProduct with ${widget.listedUserId}');
                                }
                              },
                              child: const Text(
                                'Request Exchange',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
