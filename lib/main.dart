import 'package:flutter/material.dart';
import 'package:guidek_project1/Annoncement_page/Chat_With_Me.dart';
import 'Signup&Login/home.dart';
import 'Signup&Login/login.dart';
import 'Signup&Login/signup.dart';
import 'Signup&Login/forgot_password.dart';
import 'Annoncement_page/Home_Annoncement_page.dart';
import 'Annoncement_page/GPA_Calculator.dart';
<<<<<<< HEAD
import 'package:flutter_gemini/flutter_gemini.dart';
import 'consts.dart';
=======
import 'Annoncement_page/Chat_With_Me.dart';
import 'consts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
>>>>>>> fd64b8b2e850f6abff25c8a4a595333cf9fa01a9

void main() {
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
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
        '/Chat_With_Me': (context) =>const ChatWithMe(),
      },
    );
  }
}
