import 'package:flutter/material.dart';
import 'package:beautybookingsaloon/SQLite/SQLite.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final db = await DatabaseHelper.instance.database;
    final users = await db.query('users');
    setState(() {
      _users = users;
    });
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        final nameController = TextEditingController(text: user['name']);
        final emailController = TextEditingController(text: user['email']);
        final phoneController =
            TextEditingController(text: user['phone'].toString());
        final usernameController =
            TextEditingController(text: user['username']);
        final passwordController =
            TextEditingController(text: user['password']);

        return AlertDialog(
          backgroundColor: Colors.pink[50],
          title: Center(
            child: Text(
              'User Details',
              style: TextStyle(
                fontSize: 18,
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Name', nameController),
                SizedBox(height: 10),
                _buildTextField('Email', emailController),
                SizedBox(height: 10),
                _buildTextField('Phone', phoneController),
                SizedBox(height: 10),
                _buildTextField('Username', usernameController),
                SizedBox(height: 10),
                _buildTextField('Password', passwordController,
                    obscureText: true),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final db = await DatabaseHelper.instance.database;
                  await db.update(
                    'users',
                    {
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone': int.parse(phoneController.text),
                      'username': usernameController.text,
                      'password': passwordController.text,
                    },
                    where: 'userid = ?',
                    whereArgs: [user['userid']],
                  );
                  _loadUsers();
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.update, color: Colors.white),
              label: const Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final db = await DatabaseHelper.instance.database;
                await db.delete(
                  'users',
                  where: 'userid = ?',
                  whereArgs: [user['userid']],
                );
                _loadUsers();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.delete, color: Colors.white),
              label: const Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.pink),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.pink),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.pink),
        ),
        filled: true,
        fillColor: Colors.pink[50],
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      color: Colors.pink[50],
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: Colors.pink[100],
          child: Icon(Icons.person, color: Colors.pink[900]),
        ),
        title: Text(
          user['username'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.pink[900],
          ),
        ),
        subtitle: Text(
          'User ID: ${user['userid']}',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.pink[700],
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline, color: Colors.pink),
          onPressed: () => _showUserDetails(user),
        ),
      ),
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
          'User Details',
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _users.isEmpty
            ? Center(
                child: Text(
                  'No users found',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 18.0,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return _buildUserCard(user);
                },
              ),
      ),
    );
  }
}
