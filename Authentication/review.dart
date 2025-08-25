import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  static const routeName = '/review';

  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  double rating = 1.0; // Initial value for the rating slider
  String? review;
  List<ReviewItem> reviews = [];

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();

    var newReview = ReviewItem(
      userName: 'User',
      rating: rating,
      review: review!,
    );

    _formKey.currentState?.reset();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.pink[50],
          title: const Text('Review Submitted', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('User: ${newReview.userName}', style: TextStyle(color: Colors.pink[900])),
              Text('Rating: ${newReview.rating}', style: TextStyle(color: Colors.pink[900])),
              Text('Review: ${newReview.review}', style: TextStyle(color: Colors.pink[900])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.pink)),
            ),
          ],
        );
      },
    );

    setState(() {
      reviews.add(newReview);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Salon Reviews", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/review.jpg', // Replace with your image asset
                    width: 350,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "Give Rating and Review",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Rating',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
                Slider(
                  value: rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: rating.round().toString(),
                  activeColor: Colors.pink,
                  inactiveColor: Colors.pink[100],
                  onChanged: (value) {
                    setState(() {
                      rating = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Write a Review',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.pink[50],
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please write your review!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    review = value!;
                  },
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  "All Reviews",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'User: ${reviews[index].userName}',
                                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Rating: ${reviews[index].rating}',
                                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              reviews[index].review,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReviewItem {
  final String userName;
  final double rating;
  final String review;

  ReviewItem({
    required this.userName,
    required this.rating,
    required this.review,
  });
}
