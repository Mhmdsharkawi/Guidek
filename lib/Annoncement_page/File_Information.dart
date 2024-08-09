import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart'; 

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = 'zaid';
  String _lastName = 'Nsour';
  String _email = 'zaid@example.com';
  String _phoneNumber = '';
  String? _profileImagePath;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _profileImagePath = pickedFile.path;
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImagePath', pickedFile.path);
    }
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'Zaid';
      _lastName = prefs.getString('lastName') ?? 'Nsour';
      _email = prefs.getString('email') ?? 'zaid@example.com';
      _phoneNumber = prefs.getString('phoneNumber') ?? '';
      _profileImagePath = prefs.getString('profileImagePath');
      if (_profileImagePath != null) {
        _image = File(_profileImagePath!);
      }
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', _firstName);
    prefs.setString('lastName', _lastName);
    prefs.setString('email', _email);
    prefs.setString('phoneNumber', _phoneNumber);
    prefs.setString('profileImagePath', _profileImagePath ?? '');
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveProfileData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('saveChanges'.tr())), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'profileTitle'.tr(), 
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
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
                '$_firstName $_lastName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Acumin Variable Concept',
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildTextField('firstName'.tr(), _firstName, false), 
            _buildTextField('lastName'.tr(), _lastName, false), 
            _buildTextField('emailAddress'.tr(), _email, false),
            _buildTextField('phoneNumber'.tr(), _phoneNumber, false), 
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: Text('saveChanges'.tr()), 
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
          SizedBox(height: 5),
          TextFormField(
            initialValue: initialValue,
            readOnly: readOnly,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Acumin Variable Concept',
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF2E7D32),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                if (labelText == 'firstName'.tr()) {
                  _firstName = value;
                } else if (labelText == 'lastName'.tr()) {
                  _lastName = value;
                } else if (labelText == 'emailAddress'.tr()) {
                  _email = value;
                } else if (labelText == 'phoneNumber'.tr()) {
                  _phoneNumber = value;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
