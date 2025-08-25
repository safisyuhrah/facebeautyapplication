import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beautybookingsaloon/SQLite/SQLite.dart';
import 'home.dart';

class BookingScreen extends StatefulWidget {
  final int userId;

  BookingScreen({required this.userId});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _appointmentDateController = TextEditingController();
  final TextEditingController _appointmentTimeController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _numGuestController = TextEditingController();
  final TextEditingController _packagePriceController = TextEditingController();

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        controller.text = DateFormat('HH:mm').format(dt);
      });
    }
  }

  Widget _buildDatePicker(String label, TextEditingController controller, VoidCallback onTap) {
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
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.pink[50],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.text.isEmpty ? 'Select $label' : controller.text,
                  style: TextStyle(fontSize: 16),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.pink,
                ),
              ],
            ),
          ),
        ),
      ],
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
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
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
        ),
      ],
    );
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_dateController.text.isEmpty || _timeController.text.isEmpty || _appointmentDateController.text.isEmpty || _appointmentTimeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select all date and time fields')),
        );
        return;
      }
      final db = await DatabaseHelper.instance.database;
      await db.insert('beautybook', {
        'userid': widget.userId,
        'bookdate': _dateController.text,
        'booktime': _timeController.text,
        'appointmentdate': _appointmentDateController.text,
        'appointmenttime': _appointmentTimeController.text,
        'facebeautypackage': _packageController.text,
        'numguest': int.parse(_numGuestController.text),
        'packageprice': double.parse(_packagePriceController.text),
      });
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.pink[50],
            title: Text('Booking Successful', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
            content: Text('Your booking has been confirmed!', style: TextStyle(color: Colors.pink[900])),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(userId: widget.userId),
                    ),
                  );
                },
                child: Text('OK', style: TextStyle(color: Colors.pink)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        elevation: 0,
        title: Text(
          'Booking Form',
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
                  'assets/slay.jpg', // Replace with your image asset
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              _buildDatePicker('Booking Date', _dateController, () => _selectDate(context, _dateController)),
              SizedBox(height: 10),
              _buildDatePicker('Booking Time', _timeController, () => _selectTime(context, _timeController)),
              SizedBox(height: 10),
              _buildDatePicker('Appointment Date', _appointmentDateController, () => _selectDate(context, _appointmentDateController)),
              SizedBox(height: 10),
              _buildDatePicker('Appointment Time', _appointmentTimeController, () => _selectTime(context, _appointmentTimeController)),
              SizedBox(height: 10),
              _buildTextField('Package', _packageController),
              SizedBox(height: 10),
              _buildTextField('Number of Guests', _numGuestController, keyboardType: TextInputType.number),
              SizedBox(height: 10),
              _buildTextField('Package Price', _packagePriceController, keyboardType: TextInputType.number),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Confirm Booking',
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
