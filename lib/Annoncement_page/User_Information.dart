import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String _fullname;
  late String _studentId;
  late String _email;
  late String _phone;
  late String _major;
  late bool _isLoading;
  late String _accessToken;
  ImageProvider _profileImage = AssetImage('assets/default_image.jpg'); // Provide a default value

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _profileImageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfileImage();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken') ?? '';
    final filename = prefs.getString('userImgUrl') ?? '';

    try {
      // Fetch user info
      final response = await http.get(
        Uri.parse('https://guidekproject.onrender.com/users/current_user_info'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _fullname = data['fullname'] ?? '';
          _studentId = data['number'] ?? '';
          _email = data['email'] ?? '';
          _phone = data['phone'] ?? '';
          _major = data['major_name'] ?? ''; // Add major field
          _profileImage = filename.isNotEmpty
              ? NetworkImage('https://guidekproject.onrender.com/users/get_image/$filename')
              : AssetImage('assets/default_image.jpg');
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final filename = prefs.getString('userImgUrl');
    final accessToken = prefs.getString('accessToken');

    String imageUrl;
    if (filename != null && filename.isNotEmpty) {
      imageUrl = 'https://guidekproject.onrender.com/users/get_image/$filename';
    } else {
      imageUrl = 'https://guidekproject.onrender.com/users/get_image/default_image.jpg';
    }

    try {
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.startsWith('image/')) {
          setState(() {
            _profileImage = MemoryImage(response.bodyBytes);
          });
        } else {
          print('Response is not an image, content-type: $contentType');
          setState(() {
            _profileImage = AssetImage('assets/default_image.jpg');
          });
        }
      } else {
        print('Failed to load profile image, status code: ${response.statusCode}');
        setState(() {
          _profileImage = AssetImage('assets/default_image.jpg');
        });
      }
    } catch (e) {
      print('Error loading profile image: $e');
      setState(() {
        _profileImage = AssetImage('assets/default_image.jpg');
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
        _profileImage = FileImage(_profileImageFile!);
      });
      await _uploadProfileImage();
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImageFile == null) return;

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('https://guidekproject.onrender.com/users/update_user_info'),
      );
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _profileImageFile!.path,
      ));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        print('Image uploaded successfully: ${data['message']}');
      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form state

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      // Prepare the JSON data
      final data = {
        'fullname': _fullname,
        'number': _studentId,
        'phone': _phone,
        // 'major_name': _majorName, // Major is read-only
      };

      try {
        final response = await http.put(
          Uri.parse('https://guidekproject.onrender.com/users/update_user_info'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print('Form submitted successfully: ${responseData['message']}');
          // Optionally navigate to another page or show a success message
        } else {
          print('Failed to submit form: ${response.statusCode}');
          // Handle the error response
        }
      } catch (e) {
        print('Error submitting form: $e');
        // Handle the exception
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = Color(0xFF318c3c);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              'Profile',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.normal, color: Colors.white),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundImage: _profileImageFile != null
                          ? FileImage(_profileImageFile!)
                          : _profileImage,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _pickImage,
                      color: appBarColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _fullname,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: appBarColor),
                      ),
                      onSaved: (value) => _fullname = value!,
                      cursorColor: appBarColor,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _studentId,
                      decoration: InputDecoration(
                        labelText: 'Student ID',
                        labelStyle: TextStyle(color: appBarColor),
                      ),
                      onSaved: (value) => _studentId = value!,
                      cursorColor: appBarColor,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: TextStyle(color: appBarColor),
                      ),
                      onSaved: (value) => _email = value!,
                      cursorColor: appBarColor,
                      enabled: false, // Email field is read-only
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: appBarColor),
                      ),
                      onSaved: (value) => _phone = value!,
                      cursorColor: appBarColor,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _major,
                      decoration: InputDecoration(
                        labelText: 'Major',
                        labelStyle: TextStyle(color: appBarColor),
                      ),
                      enabled: false, // Major field is read-only
                      cursorColor: appBarColor,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Save Changes',style: TextStyle(color: Color(0xFFfdcd90)),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appBarColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
