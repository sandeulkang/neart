import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neart/homepage.dart';
import 'package:neart/authenticationpage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:neart/search_screen.dart';
import 'dart:io';
import 'Page/page5_null.dart';
import 'Page/page5_on.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  HttpOverrides.global = MyHttpOverrides();
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
        '/Authentication': (context) => const Authentication(),
        '/Page5_on': (context) => const Page5_on(),
        '/Page5_null': (context) => const Page5_null(),
        '/SearchScreen' :(context) => SearchScreen()
      },
      home: const HomePage(),
    );
  }
}
