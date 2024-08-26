import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 10.0),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'ar') {
                      context.setLocale(const Locale('ar'));
                    } else if (value == 'en') {
                      context.setLocale(const Locale('en'));
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    PopupMenuItem(
                      value: 'ar',
                      child: Text('العربية'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  icon: const Icon(Icons.email, color: Colors.white),
                  label: Text(
                    tr('signup_with_email'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(const BorderSide(color: Colors.white, width: 2)),
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.white.withOpacity(0.2);
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    setState(() {
                      _isHovering = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _isHovering = false;
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: tr('already_have_account'),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                            text: tr('login_here'),
                            style: TextStyle(
                              color: _isHovering ? Colors.blue : Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: _isHovering ? Colors.blue : Colors.white,
                              decorationThickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  tr('agree_terms'),
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
