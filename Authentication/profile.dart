// lib/screens/profile.dart
import 'package:flutter/material.dart';
import 'package:beautybookingsaloon/SQLite/SQLite.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final db = await DatabaseHelper.instance.database;
    final user = await db.query(
      'users',
      where: 'userid = ?',
      whereArgs: [widget.userId],
    );
    if (user.isNotEmpty) {
      setState(() {
        _nameController.text = user[0]['name'] as String;
        _emailController.text = user[0]['email'] as String;
        _phoneController.text = user[0]['phone'].toString();
        _usernameController.text = user[0]['username'] as String;
        _passwordController.text = user[0]['password'] as String;
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.pink,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.pink[50],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        title: Text(
          'My Profile',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/update.jpg",
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Name', _nameController),
              SizedBox(height: 10),
              _buildTextField('Email', _emailController),
              SizedBox(height: 10),
              _buildTextField('Phone', _phoneController),
              SizedBox(height: 10),
              _buildTextField('Username', _usernameController),
              SizedBox(height: 10),
              _buildTextField('Password', _passwordController,
                  obscureText: true),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final db = await DatabaseHelper.instance.database;
                      await db.update(
                        'users',
                        {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'phone': int.parse(_phoneController.text),
                          'username': _usernameController.text,
                          'password': _passwordController.text,
                        },
                        where: 'userid = ?',
                        whereArgs: [widget.userId],
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile updated')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
