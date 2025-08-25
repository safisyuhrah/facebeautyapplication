import 'package:flutter/material.dart';
import 'package:beautybookingsaloon/SQLite/SQLite.dart';
import 'package:beautybookingsaloon/Authentication/payment.dart';

class ManageBookingsScreen extends StatefulWidget {
  final int userId;
  final bool isAdmin;

  const ManageBookingsScreen({required this.userId, required this.isAdmin});

  @override
  _ManageBookingsScreenState createState() => _ManageBookingsScreenState();
}

class _ManageBookingsScreenState extends State<ManageBookingsScreen> {
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> bookings = [];
    try {
      if (widget.isAdmin) {
        bookings = await db.query('beautybook');
      } else {
        bookings = await db.query('beautybook', where: 'userid = ?', whereArgs: [widget.userId]);
      }

      // Debugging: Print the bookings list to inspect its structure
      print("Bookings Data for userId ${widget.userId}: $bookings");
      for (var booking in bookings) {
        print("Booking type: ${booking.runtimeType}, Value: $booking");
        booking.forEach((key, value) {
          print("Key: $key, Type: ${value.runtimeType}, Value: $value");
        });
      }

    } catch (e) {
      print("Error loading bookings: $e");
    }

    setState(() {
      _bookings = bookings;
    });
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        final _dateController = TextEditingController(text: booking['bookdate']);
        final _timeController = TextEditingController(text: booking['booktime']);
        final _appointmentDateController = TextEditingController(text: booking['appointmentdate']);
        final _appointmentTimeController = TextEditingController(text: booking['appointmenttime']);
        final _packageController = TextEditingController(text: booking['facebeautypackage']);
        final _numGuestController = TextEditingController(text: booking['numguest'].toString());
        final _packagePriceController = TextEditingController(text: booking['packageprice'].toString());

        return AlertDialog(
          backgroundColor: Colors.pink[50],
          title: Center(
            child: Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField('Booking ID', TextEditingController(text: booking['bookid'].toString()), readOnly: true),
                  SizedBox(height: 10),
                  _buildTextField('Booking Date', _dateController),
                  SizedBox(height: 10),
                  _buildTextField('Booking Time', _timeController),
                  SizedBox(height: 10),
                  _buildTextField('Appointment Date', _appointmentDateController),
                  SizedBox(height: 10),
                  _buildTextField('Appointment Time', _appointmentTimeController),
                  SizedBox(height: 10),
                  _buildTextField('Package', _packageController),
                  SizedBox(height: 10),
                  _buildTextField('Number of Guests', _numGuestController),
                  SizedBox(height: 10),
                  _buildTextField('Package Price', _packagePriceController),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final db = await DatabaseHelper.instance.database;
                      await db.update(
                        'beautybook',
                        {
                          'bookdate': _dateController.text,
                          'booktime': _timeController.text,
                          'appointmentdate': _appointmentDateController.text,
                          'appointmenttime': _appointmentTimeController.text,
                          'facebeautypackage': _packageController.text,
                          'numguest': int.parse(_numGuestController.text),
                          'packageprice': double.parse(_packagePriceController.text),
                        },
                        where: 'bookid = ?',
                        whereArgs: [booking['bookid']],
                      );
                      _loadBookings();
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final db = await DatabaseHelper.instance.database;
                    await db.delete(
                      'beautybook',
                      where: 'bookid = ?',
                      whereArgs: [booking['bookid']],
                    );
                    _loadBookings();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
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

  Widget _buildPaymentButton(BuildContext context, double packagePrice, int numGuests) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                userId: widget.userId,
                packagePrice: packagePrice,
                numGuests: numGuests,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: Colors.white, size: 30.0),
            SizedBox(width: 10),
            Text(
              'Payment',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
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
          'Booking Details',
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            return Card(
              color: Colors.pink[50],
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  booking['facebeautypackage'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.pink,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    _buildBookingDetailRow(Icons.confirmation_number, 'Booking ID:', booking['bookid'].toString()),
                    SizedBox(height: 5),
                    _buildBookingDetailRow(Icons.calendar_today, 'Booking Date:', booking['bookdate']),
                    SizedBox(height: 5),
                    _buildBookingDetailRow(Icons.access_time, 'Booking Time:', booking['booktime']),
                    SizedBox(height: 5),
                    _buildBookingDetailRow(Icons.calendar_today, 'Appointment Date:', booking['appointmentdate']),
                    SizedBox(height: 5),
                    _buildBookingDetailRow(Icons.access_time, 'Appointment Time:', booking['appointmenttime']),
                    SizedBox(height: 5),
                    _buildBookingDetailRow(Icons.people, 'Number of Guests:', booking['numguest'].toString()),
                    SizedBox(height: 5),
                    _buildBookingDetailRow(Icons.attach_money, 'Package Price:', 'RM${booking['packageprice'].toStringAsFixed(2)}'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.pink),
                          onPressed: () => _showBookingDetails(booking),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.pink),
                          onPressed: () async {
                            final db = await DatabaseHelper.instance.database;
                            await db.delete(
                              'beautybook',
                              where: 'bookid = ?',
                              whereArgs: [booking['bookid']],
                            );
                            _loadBookings();
                          },
                        ),
                      ],
                    ),
                    if (!widget.isAdmin) ...[
                      SizedBox(height: 10),
                      _buildPaymentButton(context, booking['packageprice'], booking['numguest']),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBookingDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.pink),
        SizedBox(width: 10),
        Text(
          '$label $value',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
