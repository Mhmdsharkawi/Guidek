import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';


class AppInfoPage extends StatelessWidget {
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        title: Text(
          tr('app_info'),
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Color(0xFFDCF5DC),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 12,
                color: Color(0xFFfdcd90),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 12,
                    color: Color(0xFFfdcd90),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/guidek[1].png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'v 1.0',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Acumin Variable Concept',
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr('created_by'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Acumin Variable Concept',
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  tr('frontend_ui_design'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontFamily: 'Acumin Variable Concept',
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  '- Mohammad Al_Sharkawi\n- Obaidullah Khuraisat\n- Salah El-Din Anouqa ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Acumin Variable Concept',
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  tr('backend_database'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                    fontFamily: 'Acumin Variable Concept',
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  '- Zaid Al_Nsour\n- Obaidullah Khuraisat',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Acumin Variable Concept',
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  tr('project_mentor'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    fontFamily: 'Acumin Variable Concept',
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  ' - Adnan Al-Rabea',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Acumin Variable Concept',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
