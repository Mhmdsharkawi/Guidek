import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _studentID = '';
  String _email = '';
  String _phoneNumber = '';
  String? _profileImagePath;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();  // Load data when the page initializes
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('userFullName') ?? 'Zaid Nsour';
      _studentID = prefs.getString('userNumber') ?? '';
      _email = prefs.getString('userEmail') ?? 'zaid@example.com';
      _phoneNumber = prefs.getString('userPhone') ?? '';
      _profileImagePath = prefs.getString('userImgUrl');
      if (_profileImagePath != null) {
        _image = File(_profileImagePath!);
      }
    });
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _profileImagePath = pickedFile.path;
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://guidekproject.onrender.com/users/upload_image'),
    );

    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Upload response status: ${response.statusCode}');
      print('Upload response body: $responseBody');
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['message'] == 'Image uploaded successfully.') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userImgUrl', _image!.path);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image'), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userFullName', _fullName);
    prefs.setString('userPhone', _phoneNumber);
    prefs.setString('userImgUrl', _profileImagePath ?? '');
    prefs.setString('userNumber', _studentID);

    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('https://guidekproject.onrender.com/users/update_user_info'),
    );

    request.fields['json_data'] = jsonEncode({
      'fullname': _fullName,
      'number': _studentID,
      'phone': _phoneNumber,
      'major_name': 'Computer Science', // Example, replace with actual major if needed
    });

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Update response status: ${response.statusCode}');
      print('Update response body: $responseBody');
      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['message'] == 'User Profile updated successfully.') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile'), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile'), backgroundColor: Colors.red),
      );
    }
  }
  
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'profileTitle',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF318C3C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 12,
                color: Color(0xFFfdcd90),
              ),
              _buildProfileHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: getImage,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  child: _image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.file(
                      _image!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green,
                      width: 4,
                    ),
                  ),
                ),
                Container(
                  width: 134,
                  height: 134,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFfdcd90),
                      width: 2.6,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xFF318C3C),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                _fullName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Acumin Variable Concept',
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildTextField('Full Name', _fullName, false),
            _buildTextField('Student ID', _studentID, false),
            _buildTextField('Email Address', _email, false),
            _buildTextField('Phone Number', _phoneNumber, false),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Acumin Variable Concept',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Color(0xFFfdcd90),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, String initialValue, bool readOnly) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Acumin Variable Concept',
            ),
          ),
          TextFormField(
            initialValue: initialValue,
            readOnly: readOnly,
            onSaved: (value) {
              if (labelText == 'Full Name') {
                _fullName = value ?? '';
              } else if (labelText == 'Student ID') {
                _studentID = value ?? '';
              } else if (labelText == 'Email Address') {
                _email = value ?? '';
              } else if (labelText == 'Phone Number') {
                _phoneNumber = value ?? '';
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Acumin Variable Concept',
            ),
          ),
        ],
      ),
    );
  }
}
