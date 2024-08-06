import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF318c3c),
        title: const Text(
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
        height: double.infinity,  // Ensures the container covers the full height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/contact-us.jpg'), // استبدل بمسار الصورة الفعلي
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Developers',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoSection(
                Icons.email,
                'E-mail',
                [
                  'mohammadalsharkawi2@gmail.com',
                  'obaidullahkh204@gmail.com',
                  'fadfdsa@bgfs.dsd',
                  'dfvmjkls@htrs.gv',
                ],
                const Color(0xFFfdcd90), // Yellow color
              ),
              const SizedBox(height: 20),
              _buildInfoSection(
                Icons.phone,
                'Mobile',
                [
                  'Mohammad Alsharkawi: 0795508192',
                  'Obaidullah Khuraisat: 0771001023',
                  'Salah El-Din Anouqa: 0799713509',
                  'Zaid Al_Nsour: 0782494403',
                ],
                const Color(0xff3a8c31), // Green color
              ),
              const SizedBox(height: 20),
              _buildInfoSection(
                Icons.code,
                'Github',
                [
                  'mhmdsharkawi',
                  'obaidullahkh2003',
                  'SalahAnnuka',
                  'UsrFourz',
                ],
                const Color(0xFF9C27B0), // Purple color
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
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        )),
      ],
    );
  }
}
