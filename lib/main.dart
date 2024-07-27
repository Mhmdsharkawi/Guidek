import 'package:flutter/material.dart';
import 'Signup&Login/home.dart';
import 'Signup&Login/login.dart';
import 'Signup&Login/signup.dart';
import 'Signup&Login/forgot_password.dart';
import 'Annoncement_page/Home_Annoncement_page.dart';
import 'Annoncement_page/GPA_Calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/Home_Annoncament_page': (context) => HomeAnnoncementPage(),
        '/GPA_Calculator': (context) => GpaCalculator(),
      },
    );
  }
}
