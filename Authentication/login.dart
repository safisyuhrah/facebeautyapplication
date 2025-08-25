import 'package:flutter/material.dart';
import 'package:beautybookingsaloon/SQLite/SQLite.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
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
                child: Image.asset(
                  "assets/hair.png",
                  width: 300,
                ),
              ),
              SizedBox(height: 20),
              _buildTitle('W E L C O M E'),
              SizedBox(height: 20), // Increased space
              _buildTextField('Username', _usernameController),
              SizedBox(height: 20), // Increased space
              _buildTextField('Password', _passwordController, obscureText: true),
              SizedBox(height: 40),
              _buildLoginButton(context),
              SizedBox(height: 20), // Increased space
              _buildSignupText(context),
              SizedBox(height: 20), // Increased space
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAdminLoginButton(context),
                  SizedBox(width: 20), // Space between buttons
                  SizedBox(width: 20), // Space between buttons
                  _buildContinueWithoutLoginButton(context),
                ],
              ),
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
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
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

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final db = await DatabaseHelper.instance.database;
            final result = await db.query(
              'users',
              where: 'username = ? AND password = ?',
              whereArgs: [_usernameController.text, _passwordController.text],
            );
            if (result.isNotEmpty) {
              final userId = result[0]['userid'] as int;
              print('Logged in as User ID: $userId'); // Debug print
              Navigator.pushReplacementNamed(
                context,
                '/home',
                arguments: userId,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid Username or Password'),
                ),
              );
            }
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
          'Login',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Roboto', // Updated font
          ),
        ),
      ),
    );
  }

  Widget _buildSignupText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register'); // Navigates to the register screen
      },
      child: Text(
        "Don't have an account? Sign up",
        style: TextStyle(
          color: Colors.pink,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAdminLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/admin_login');
      },
      child: Text(
        'Admin Login',
        style: TextStyle(
          fontSize: 12,
          color: Colors.pink,
        ),
      ),
    );
  }


  Widget _buildContinueWithoutLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/home',
            arguments: 0); // Navigate to home without userId
      },
      child: Text(
        'Package Details',
        style: TextStyle(
          fontSize: 12,
          color: Colors.pink,
        ),
      ),
    );
  }
}
