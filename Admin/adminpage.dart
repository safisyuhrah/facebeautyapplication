import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  final bool isAdmin;

  const AdminHomeScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/customize.png',
              width: 50,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/banner.jpg', // Add your image here
                width: 200,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
            _buildTitle('Admin Page'),
            const SizedBox(height: 20),
            _buildHorizontalButtons(context),
            const SizedBox(height: 20),
            _buildLogoutText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.pink,
      ),
    );
  }

  Widget _buildHorizontalButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFlatButton(context, 'All User Details', '/manage_users'),
        _buildFlatButton(context, 'All Booking Details', '/manage_bookings'),
      ],
    );
  }

  Widget _buildFlatButton(BuildContext context, String text, String route) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route, arguments: {
          'userId': 0, // Assuming admin userId is not required
          'isAdmin': isAdmin
        });
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.pink,
        ),
      ),
    );
  }

  Widget _buildLogoutText(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/admin_login');
        },
        child: Text(
          'Exit',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
