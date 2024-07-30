import 'dart:async';
import 'package:flutter/material.dart';
import 'package:money/screen/homeScreen.dart';
import 'package:money/screen/login.dart';
import 'package:money/sharePrefrence/sharePrefrence.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    await PrefrenceManager.getLoginStatus();
  Timer(const Duration(seconds: 3), _navigateUser);
  }

  Future<void> _navigateUser() async {
    bool isLoggedIn = await PrefrenceManager.getLoginStatus();
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  Homescreen()),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/icons/money.png',color: Colors.green,),
            ),
            const SizedBox(height: 20),
            const Text(
              'Track Your Expence... ',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
