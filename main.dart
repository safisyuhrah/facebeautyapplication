import 'package:flutter/material.dart';
import 'package:beautybookingsaloon/Authentication/bookingform.dart';
import 'package:beautybookingsaloon/Authentication/home.dart';
import 'package:beautybookingsaloon/Authentication/login.dart';
import 'package:beautybookingsaloon/Authentication/payment.dart';
import 'package:beautybookingsaloon/Authentication/profile.dart';
import 'package:beautybookingsaloon/Authentication/register.dart';
import 'package:beautybookingsaloon/Admin/adminpage.dart';
import 'package:beautybookingsaloon/Admin/adminlogin.dart';
import 'package:beautybookingsaloon/JsonModel/bookingdetails.dart'; 
import 'package:beautybookingsaloon/JsonModel/userdetails.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Beauty Booking',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => RegisterScreen());
          case '/home':
            final userId = settings.arguments as int? ?? 0;
            return MaterialPageRoute(builder: (context) => HomeScreen(userId: userId));
          case '/profile':
            final userId = settings.arguments as int? ?? 0;
            return MaterialPageRoute(builder: (context) => ProfileScreen(userId: userId));
          case '/booking':
            final userId = settings.arguments as int? ?? 0;
            return MaterialPageRoute(builder: (context) => BookingScreen(userId: userId));
          case '/admin_login':
            return MaterialPageRoute(builder: (context) => AdminLoginScreen());
          case '/admin_home':
            final isAdmin = settings.arguments as bool? ?? false;
            return MaterialPageRoute(builder: (context) => AdminHomeScreen(isAdmin: isAdmin));
          case '/manage_users':
            return MaterialPageRoute(builder: (context) => ManageUsersScreen());
          case '/payment':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null) {
              return MaterialPageRoute(builder: (context) => PaymentScreen(
                userId: args['userId'] as int,
                packagePrice: args['packagePrice'] as double,
                numGuests: args['numGuests'] as int,
              ));
            }
            return MaterialPageRoute(builder: (context) => PaymentScreen(userId: 0, packagePrice: 100.0, numGuests: 1));
          case '/manage_bookings':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(builder: (context) => ManageBookingsScreen(
              userId: args['userId'] as int,
              isAdmin: args['isAdmin'] as bool,
            ));
          default:
            return null;
        }
      },
    );
  }
}
