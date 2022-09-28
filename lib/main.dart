import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neart/homepage.dart';
import 'package:neart/loginpage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'Page/page5.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumSquare',
        appBarTheme: const AppBarTheme(
          color: Colors.white10,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Roboto'),
          iconTheme: IconThemeData(color: Colors.black, size: 25)
        ),
        textTheme: TextTheme().copyWith(bodyText2: TextStyle(fontSize: 12,letterSpacing: 0.7),),
        //Theme.of(context).textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black,)
      ),
      title: 'Neart',
      routes: {
        '/LoginPage': (context) => const LoginPage(),
      },
      home: const HomePage(),
    );
  }
}
