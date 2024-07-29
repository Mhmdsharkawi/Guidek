import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = 'Zaid';
  String _lastName = 'Nsour';
  String _email = 'Zaiddoe@gnail.com';
  String _phoneNumber = '';
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
      });
      // Save the image path
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImagePath', pickedFile.path);
    }
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? 'John'; // ينربط بالباك
      _lastName = prefs.getString('lastName') ?? 'Doe'; //
      _email = prefs.getString('email') ?? 'john.doe@example.com'; //
      _phoneNumber = prefs.getString('phoneNumber') ?? ''; // optional
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', _firstName);
    prefs.setString('lastName', _lastName);
    prefs.setString('email', _email);
    prefs.setString('phoneNumber', _phoneNumber);
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveProfileData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            fontSize: 30,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF318C3C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                height: 8,
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
                      color: Colors.orangeAccent,
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
                'Zaid Nsour',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Acumin Variable Concept',
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildTextField('First Name', _firstName, true),
            _buildTextField('Last Name', _lastName, true),
            _buildTextField('E-mail Address', _email, true),
            _buildTextField('Phone Number', _phoneNumber, false),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                child: Text('Save Changes'),
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFDCD90),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, bool readOnly) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
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
                if (label == 'First Name') {
                  _firstName = value;
                } else if (label == 'Last Name') {
                  _lastName = value;
                } else if (label == 'E-mail Address') {
                  _email = value;
                } else if (label == 'Phone Number') {
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
