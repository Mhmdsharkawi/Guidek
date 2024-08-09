import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guidek_project1/Annoncement_page/Chat_With_Me.dart';
import 'Signup&Login/home.dart';
import 'Signup&Login/login.dart';
import 'Signup&Login/signup.dart';
import 'Signup&Login/forgot_password.dart';
import 'Annoncement_page/Home_Annoncement_page.dart';
import 'Annoncement_page/GPA_Calculator.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'consts.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Gemini.init(apiKey: GEMINI_API_KEY);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? expirationDateString = prefs.getString('loginExpiration');

  if (isLoggedIn && expirationDateString != null) {
    DateTime expirationDate = DateTime.parse(expirationDateString);
    if (DateTime.now().isBefore(expirationDate)) {
      runApp(
        EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/langs',
          fallbackLocale: Locale('en'),
          child: MyApp(initialRoute: '/Home_Annoncament_page'),
        ),
      );
    } else {
      await prefs.clear();
      runApp(
        EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/langs',
          fallbackLocale: Locale('en'),
          child: const MyApp(initialRoute: '/'),
        ),
      );
    }
  } else {
    runApp(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/langs',
        fallbackLocale: Locale('en'),
        child: const MyApp(initialRoute: '/'),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, this.initialRoute = '/'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/Home_Annoncament_page': (context) => HomeAnnoncementPage(),
        '/GPA_Calculator': (context) => GpaCalculator(),
        '/Chat_With_Me': (context) => const ChatWithMe(),
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
