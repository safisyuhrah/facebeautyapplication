import 'package:flutter/material.dart';
import 'packagedetails.dart';
import 'bookingform.dart';

class HomeScreen extends StatelessWidget {
  final int userId;

  HomeScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    print('Navigated to HomeScreen with User ID: $userId'); // Debug print
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Text(
              'Sweet Berry',
              style: TextStyle(
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          if (userId != 0) _buildProfileButton(context, '/profile'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Packages',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              SizedBox(height: 20),
              _buildPackageSection(context),
              if (userId != 0) ...[
                SizedBox(height: 40),
                _buildBookNowBox(context),
                SizedBox(height: 20),
                _buildManageBookingsButton(context),
              ],
              if (userId == 0) ...[
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Login or Register to book with us!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(context, 'Login', '/login'),
                    _buildButton(context, 'Register', '/register'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookNowBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingScreen(userId: userId),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'BOOK NOW',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManageBookingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Navigating to ManageBookingsScreen with User ID: $userId'); // Debug print
        Navigator.pushNamed(context, '/manage_bookings', arguments: {
          'userId': userId,
          'isAdmin': false
        });
      },
      child: Center(
        child: Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 16,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String route) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route, arguments: userId);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.pink,
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String route) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route, arguments: userId);
        },
        child: CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/profile.png'),
        ),
      ),
    );
  }

  Widget _buildPackageSection(BuildContext context) {
    return Column(
      children: _packages.map((package) {
        return _buildPackageCard(
          context,
          package['imagePath']!,
          package['title']!,
          package['description']!,
          package['features']!,
        );
      }).toList(),
    );
  }

  final List<Map<String, dynamic>> _packages = [
    {
      'imagePath': 'assets/deep.jpg',
      'title': 'Facial Treatment 1',
      'description': 'Deep Cleansing Facial Treatment',
      'features': [
        "Package Price - RM100",
        'A deep pore cleansing facial is a dermatological type of facial treatment involving an intensely deep cleanse of the face that purifies the skin. This treatment is the best solution to achieve a clear, radiant complexion.',
      ],
    },
    {
      'imagePath': 'assets/LED.jpg',
      'title': 'Facial Treatment 2',
      'description': 'LED Facial Treatment',
      'features': [
        "Package Price - RM115",
        'LED light therapy facials can help improve the appearance of skin by penetrating deep into the skin to encourage collagen production and cell turnover. This can help reduce the appearance of fine lines, wrinkles, and dark spots, and create firmer, smoother-looking skin.',
      ],
    },
    {
      'imagePath': 'assets/microneedle.jpg',
      'title': 'Facial Treatment 3',
      'description': 'Microneedling Facial Treatment',
      'features': [
        "Package Price - RM136",
        'A process that produces more collagen and elastin to keep skin smooth and firm.',
      ],
    },
    {
      'imagePath': 'assets/keratin.jpg',
      'title': 'Hair Treatment 1',
      'description': 'Keratin Treatment',
      'features': [
        "Package Price - RM178",
        'A salon specialty service that can make hair shinier, smoother, and frizz-free.',
        'The treatment involves applying a keratin-based product to wet hair, blow-drying it, and sealing it with a flat iron.',
      ],
    },
    {
      'imagePath': 'assets/scalp.jpg',
      'title': 'Hair Treatment 2',
      'description': 'Scalp Treatment',
      'features': [
        "Package Price - RM189",
        'A product that is specifically formulated to detoxify the scalp, add moisture, and nourish scalp health, resulting in healthier-looking and shinier hair.',
      ],
    },
    {
      'imagePath': 'assets/relax.jpg',
      'title': 'Hair Treatment 3',
      'description': 'Relax Hair Treatment',
      'features': [
        "Package Price - RM89",
        'This is a very desirable thing for those with unruly curls or those that prefer straight hair and would like to be freed from the daily struggle with blow dryers and straightening irons with head tension massage.',
      ],
    },
    {
      'imagePath': 'assets/manicure.jpg',
      'title': 'Nail Treatment 1',
      'description': 'Manicure Hand Treatment',
      'features': [
        "Package Price - RM45",
        'A consists of filing and shaping the free edge, pushing and clipping (with a cuticle pusher and cuticle nippers) any nonliving tissue (but limited to the cuticle and hangnails), treatments with various liquids with hand massage.',
      ],
    },
    {
      'imagePath': 'assets/pedicure.jpg',
      'title': 'Nail Treatment 2',
      'description': 'Pedicure Leg Treatment',
      'features': [
        "Package Price - RM76",
        'A cosmetic treatment of the feet and toenails, analogous to a manicure. During a pedicure, dead skin cells are rubbed off the bottom of the feet using a rough stone (often a pumice stone) with leg massage.',
      ],
    },
    {
      'imagePath': 'assets/polish.jpg',
      'title': 'Nail Treatment 3',
      'description': 'Nail Polishing Treatment',
      'features': [
        "Package Price - RM79",
        'Nail polishing treatments can help strengthen nails that are weak, brittle, broken, or easily chipped.',
      ],
    },
  ];

  Widget _buildPackageCard(BuildContext context, String imagePath, String title,
      String description, List<String> features) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PackageDetailsScreen(
              title: title,
              imagePath: imagePath,
              description: description,
              features: features,
              userId: userId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300, // Increased height to fit the images better
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22, // Increased font size for better readability
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 18, // Increased font size for better readability
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...features.map((feature) => Text(
                        feature,
                        style: TextStyle(
                          fontSize: 16, // Increased font size for better readability
                          color: Colors.black87,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
