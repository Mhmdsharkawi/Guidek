import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
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
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  icon: const Icon(Icons.email, color: Colors.white),
                  label: const Text(
                    'Signup with Email',
                    style: TextStyle(color: Colors.white),
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
                        text: 'Already have an account? ',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Login Here',
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
                  'By signing up, you agree to our BAU terms',
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
