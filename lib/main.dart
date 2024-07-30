
import 'package:flutter/material.dart';

import 'screen/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await PrefrenceManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.green),
        appBarTheme: AppBarTheme(color: Colors.green),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
        ),


      ),
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      home: Splash(),
    );
  }
}
