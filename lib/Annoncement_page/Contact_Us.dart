import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            fontSize: 30,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/contact-us.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Developers',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              _buildInfoSection(
                Icons.email,
                'E-mail',
                [
                  'mohammadalsharkawi2@gmail.com',
                  'obaidullahkh204@gmail.com',
                  'fadfdsa@bgfs.dsd',
                  'nsourzaid1@gmail.com',
                ],
                Color(0xFFfdcd90),
              ),
              SizedBox(height: 20),
              _buildInfoSection(
                Icons.phone,
                'Mobile',
                [
                  'Mohammad Alsharkawi: 0795508192',
                  'Obaidullah Khuraisat: 0771001023',
                  'Salah El-Din Anouqa: 0799713509',
                  'Zaid Al_Nsour: 0782494403',
                ],
                Color(0xff3a8c31),
              ),
              SizedBox(height: 20),
              _buildInfoSection(
                Icons.code,
                'Github',
                [
                  'mhmdsharkawi',
                  'obaidullahkh2003',
                  'SalahAnnuka',
                  'zaidNsour',
                ],
                Color(0xFF9C27B0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(IconData icon, String title, List<String> items, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        )),
      ],
    );
  }
}
