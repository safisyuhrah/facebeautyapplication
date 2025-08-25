import 'package:flutter/material.dart';
import 'review.dart';

class PaymentScreen extends StatefulWidget {
  final int userId;
  final double packagePrice;
  final int numGuests;

  PaymentScreen(
      {required this.userId,
      required this.packagePrice,
      required this.numGuests});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _discountCodeController = TextEditingController();
  double _totalPayment = 0.0;
  double _discountAmount = 0.0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _calculateTotalPayment();
  }

  void _calculateTotalPayment() {
    setState(() {
      _totalPayment = widget.packagePrice * widget.numGuests - _discountAmount;
    });
  }

  void _applyDiscount() {
    switch (_discountCodeController.text.toUpperCase()) {
      case 'BEAUTY21':
        _discountAmount = _totalPayment * 0.1; // 10% discount
        break;
      case 'NICE67':
        _discountAmount = _totalPayment * 0.15; // 15% discount
        break;
      case 'PWETTY89':
        _discountAmount = _totalPayment * 0.2; // 20% discount
        break;
      case 'STUNN99':
        _discountAmount = _totalPayment * 0.25; // 25% discount
        break;
      case 'BDAY45':
        _discountAmount = _totalPayment * 0.3; // 30% discount
        break;
      case 'LOVER00':
        _discountAmount = _totalPayment * 0.35; // 35% discount
        break;
      case 'GLOW67':
        _discountAmount = _totalPayment * 0.4; // 40% discount
        break;
      case 'GIRL32':
        _discountAmount = _totalPayment * 0.45; // 45% discount
        break;
      case 'MINE56':
        _discountAmount = _totalPayment * 0.5; // 50% discount
        break;
      default:
        _discountAmount = 0.0;
        _errorMessage = 'Invalid discount code';
        return;
    }
    if (_discountAmount > _totalPayment) {
      _discountAmount = _totalPayment;
    }
    _errorMessage = '';
    _calculateTotalPayment();
  }

  void _pay() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            backgroundColor: Colors.pink[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Payment Successful',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(),
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
          'Payment',
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
                  'assets/payment.jpg', // Replace with your image asset
                  width: 300,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Payment',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'RM${_totalPayment.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Discount Code',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _discountCodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  filled: true,
                  fillColor: Colors.pink[50],
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
                validator: (value) => validateDiscountCode(value),
              ),
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _applyDiscount();
                    }
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              if (_errorMessage.isNotEmpty) ...[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 20),
              Text(
                'PAYMENT METHOD',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/visa.jpg', // Replace with your image asset
                      width: 70,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/debit.jpg', // Replace with your image asset
                      width: 70,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/tng.jpg', // Replace with your image asset
                      width: 70,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/apple.jpg', // Replace with your image asset
                      width: 70,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _pay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Pay',
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _navigateToReview,
                  child: Text(
                    'Give Us Review!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                      decoration: TextDecoration.underline,
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

  String? validateDiscountCode(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.toUpperCase() != 'BEAUTY21' &&
        value.toUpperCase() != 'NICE67' &&
        value.toUpperCase() != 'PWETTY89' &&
        value.toUpperCase() != 'STUNN99' &&
        value.toUpperCase() != 'BDAY45' &&
        value.toUpperCase() != 'LOVER00' &&
        value.toUpperCase() != 'GLOW67' &&
        value.toUpperCase() != 'GIRL32' &&
        value.toUpperCase() != 'MINE56') {
      return 'Invalid voucher code';
    }
    return null;
  }
}
