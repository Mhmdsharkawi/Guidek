import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:guidek_project1/Signup&Login/login.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscureText = true;
  bool _isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdController = TextEditingController();
  String? _selectedMajor;
  final _formKey = GlobalKey<FormState>();

  // List of majors for the dropdown, including 'Other' option
  final List<Map<String, String>> _majors = [
    {'name': 'Computer Science', 'value': 'Computer Science'},
    {'name': 'Software Engineering', 'value': 'Software Engineering'},
    {'name': 'Computer Information System', 'value': 'Computer Information System'},
    {'name': 'Computer Animation And Graphics', 'value': 'Computer Animation And Graphics'},
    {'name': 'Other', 'value': 'Other'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_your_name'.tr();
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_your_email'.tr();
    } else if (!EmailValidator.validate(value)) {
      return 'please_enter_a_valid_email'.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_your_password'.tr();
    } else if (value.length < 8) {
      return 'password_min_length'.tr();
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'password_uppercase'.tr();
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'password_number'.tr();
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'password_special_character'.tr();
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedMajor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('please_select_major'.tr())),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final registerUrl = 'https://guidekproject.onrender.com/auth/register';
      final verifyUrl = 'https://guidekproject.onrender.com/auth/verify_account_request';

      try {
        final registerResponse = await http.post(
          Uri.parse(registerUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'fullname': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'number': _studentIdController.text,
            'major_name': _selectedMajor!,
          }),
        );

        print('Register Response status: ${registerResponse.statusCode}');
        print('Register Response body: ${registerResponse.body}');

        if (registerResponse.statusCode == 201) {
          // Send verification email request
          final verifyResponse = await http.post(
            Uri.parse(verifyUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': _emailController.text,
            }),
          );

          print('Verify Response status: ${verifyResponse.statusCode}');
          print('Verify Response body: ${verifyResponse.body}');

          setState(() {
            _isLoading = false;
          });

          if (verifyResponse.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('registration_success'.tr())),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('verification_failed'.tr(args: [jsonDecode(verifyResponse.body)['message']]))),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('signup_failed'.tr(args: [jsonDecode(registerResponse.body)['message']]))),
          );
        }
      } catch (e) {
        print('Request failed with error: $e');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('signup_failed_network'.tr())),
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'name'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedMajor,
                      items: _majors.map((major) {
                        return DropdownMenuItem<String>(
                          value: major['value'],
                          child: Text(
                            major['name']!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMajor = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'major'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        prefixIcon: const Icon(Icons.school, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.black),
                      dropdownColor: const Color(0xf00000013),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'email_address'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
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
                      controller: _studentIdController,
                      decoration: InputDecoration(
                        labelText: 'student_id'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                        prefixIcon: const Icon(Icons.card_membership, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_your_student_id'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'password'.tr(),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
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
                    const SizedBox(height: 30),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      child: Text('sign_up'.tr(), style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Text(
                        'already_have_account'.tr(),
                        style: const TextStyle(color: Colors.white),
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
