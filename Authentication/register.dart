// lib/screens/register.dart
import 'package:flutter/material.dart';
import 'package:beautybookingsaloon/SQLite/SQLite.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        title: Text(
          'Sweet Berry Beauty Saloon',
          style: TextStyle(
            color: Colors.pink,
            fontFamily: 'Roboto', // Updated font
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Updated alignment
            children: [
              Center(
                child: Center(
                  child: Image.asset(
                    "assets/user.png",
                    width: 100,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTitle('Create Account'),
              SizedBox(height: 20),
              _buildTextField('Name', _nameController),
              SizedBox(height: 20), // Increased space
              _buildTextField('Email', _emailController),
              SizedBox(height: 20), // Increased space
              _buildTextField('Phone', _phoneController,
                  keyboardType: TextInputType.phone),
              SizedBox(height: 20), // Increased space
              _buildTextField('Username', _usernameController),
              SizedBox(height: 20), // Increased space
              _buildTextField('Password', _passwordController,
                  obscureText: true),
              SizedBox(height: 40),
              _buildRegisterButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.pink,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.pink,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Updated radius
              borderSide: BorderSide.none, // Removed border side
            ),
            filled: true,
            fillColor: Colors.pink[50],
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Updated padding
          ),
          style: TextStyle(
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final db = await DatabaseHelper.instance.database;
            await db.insert('users', {
              'name': _nameController.text,
              'email': _emailController.text,
              'phone': _phoneController.text,
              'username': _usernameController.text,
              'password': _passwordController.text,
            });
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Updated padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Updated radius
          ),
        ),
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
