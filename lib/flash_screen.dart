import 'package:flutter/material.dart';
import 'package:Exchange_Rate/main.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    deadLine();
  }

  void deadLine() async {
    await Future.delayed(Duration(seconds: 2));
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ThePageState()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spro = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: spro.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: spro.height * 0.2),
                  Image.asset("assert/rect77.png", width: 80),
                  SizedBox(height: 10),
                  Text(
                    "Exchange Rate",
                    style: TextStyle(
                      fontFamily: 'Sansation',
                      color: const Color.fromRGBO(188, 32, 36, 100),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: spro.height * 0.3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "from",
                    style: TextStyle(
                      fontFamily: 'AudioWide',
                      letterSpacing: 1,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "hacks industries",
                    style: TextStyle(
                      fontFamily: 'AudioWide',
                      fontSize: 15,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
