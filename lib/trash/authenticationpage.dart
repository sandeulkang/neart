import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:neart/Page5/page5_on.dart';
import '../Page5/page5.dart';
import '../homepage.dart';

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) { //로그인할 때
          return SignInScreen(
            providerConfigs: [EmailProviderConfiguration()],);
        }
        else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:
              (context) =>HomePage()),);
          WidgetsBinding.instance.addPostFrameCallback;
          return Page5_on();//로그인 하고 나면 그 위에 stack되며 return되는 화면, 또 로그아웃을 누르면 새로 return되는 화면
      }}
    );
  }
}

