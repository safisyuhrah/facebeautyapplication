// lib/screens/package_details.dart
import 'package:flutter/material.dart';

class PackageDetailsScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String description;
  final List<String> features;
  final int userId;

  PackageDetailsScreen({
    required this.title,
    required this.imagePath,
    required this.description,
    required this.features,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ...features
                .map((feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ))
                .toList(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
