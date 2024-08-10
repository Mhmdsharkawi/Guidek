import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Annoncement_page/Home_Annoncement_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } /*else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }*/ else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    } //else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    //return 'Password must contain at least one special character';
    //}
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final url = 'https://guidekproject.onrender.com/auth/login';  // Update to match your local setup

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        await Future.delayed(const Duration(seconds: 2));

        // Save login state
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', _emailController.text);

        // Set expiration date (30 days from now)
        DateTime expirationDate = DateTime.now().add(const Duration(days: 30));
        await prefs.setString('loginExpiration', expirationDate.toIso8601String());

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];

          // Save tokens or navigate to a new page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeAnnoncementPage()),
          );
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${jsonDecode(response.body)['message']}')),
          );
        }
      } catch (e) {
        print('Request failed with error: $e');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: Network error')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/NewGate.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}