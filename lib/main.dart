import 'package:flutter/material.dart';
import 'package:neart/homepage.dart';
import 'package:neart/loginpage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  bool data = await fetchData();
  print(data);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 12,),),
      ),
      title: 'Neart',
      routes: {
        '/LoginPage': (context) => const LoginPage(),
      },
      home: const HomePage(),
    );
  }
}

Future<bool> fetchData() async {
  bool data = false;

  // Change to API call
  await Future.delayed(Duration(seconds: 3), () {
    data = true;
  });

  return data;
}