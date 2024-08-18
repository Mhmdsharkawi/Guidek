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
  ImageProvider _profileImage = AssetImage('assets/default_image.jpg'); // Default image

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _profileImageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken') ?? '';

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

          // Update profile image URL
          _updateProfileImage(data['userImgUrl'] ?? '');
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

  Future<void> _updateProfileImage(String filename) async {
    final imageUrl = filename.isNotEmpty
        ? 'https://guidekproject.onrender.com/users/get_image/$filename'
        : 'https://guidekproject.onrender.com/users/get_image/default_image.jpg';

    try {
      final response = await http.get(
        Uri.parse(imageUrl),
        headers: {
          'Authorization': 'Bearer $_accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _profileImage = MemoryImage(response.bodyBytes);
        });
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

      // Extract the file name from the image path
      final fileName = _profileImageFile!.path.split('/').last;

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _profileImageFile!.path,
      ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: $responseBody');

        // Fetch the updated user info to get the correct image name
        final userInfoResponse = await http.get(
          Uri.parse('https://guidekproject.onrender.com/users/current_user_info'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );

        if (userInfoResponse.statusCode == 200) {
          final userInfoData = jsonDecode(userInfoResponse.body);
          final updatedImageName = userInfoData['img_url'] ?? '';

          // Save the updated image name to SharedPreferences
          await prefs.setString('userImgUrl', updatedImageName);
          print('Updated image name saved: $updatedImageName');
        } else {
          print('Failed to fetch updated user info');
        }

        print('Image uploaded successfully: ${jsonDecode(responseBody)['message']}');
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

      // Create a multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('https://guidekproject.onrender.com/users/update_user_info'),
      );

      request.headers['Authorization'] = 'Bearer $accessToken';

      // Create JSON data string
      var jsonData = jsonEncode({
        'fullname': _fullname,
        'number': _studentId,
        'phone': _phone,
        'major_name': _major,
      });

      // Add json_data field
      request.fields['json_data'] = jsonData;

      // Add image file if available
      if (_profileImageFile != null) {
        var file = await http.MultipartFile.fromPath(
          'image',
          _profileImageFile!.path,
        );
        request.files.add(file);
      }

      try {
        var response = await request.send();
        final responseBody = await response.stream.bytesToString();
        print('Response status: ${response.statusCode}');
        print('Response body: $responseBody');

        if (response.statusCode == 200) {
          // Fetch the updated user info
          final userInfoResponse = await http.get(
            Uri.parse('https://guidekproject.onrender.com/users/current_user_info'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          );

          if (userInfoResponse.statusCode == 200) {
            final userInfoData = jsonDecode(userInfoResponse.body);
            final updatedImageName = userInfoData['img_url'] ?? '';

            // Save the updated image name to SharedPreferences
            await prefs.setString('userImgUrl', updatedImageName);
            print('Updated image name saved: $updatedImageName');
          } else {
            print('Failed to fetch updated user info');
          }

          print('Form submitted successfully: ${jsonDecode(responseBody)['message']}');
        } else {
          print('Failed to submit form: ${response.statusCode}');
        }
      } catch (e) {
        print('Error submitting form: $e');
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
                      child: Text('Save Changes', style: TextStyle(color: Color(0xFFfdcd90))),
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
