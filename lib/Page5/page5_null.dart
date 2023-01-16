import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neart/Page5/page5.dart';

import '../needLoginDialog.dart';

class Page5_null extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signwithgoogle
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = await GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _auth.signInWithCredential(credential);

    return await FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set({
      'profileUrl': _auth.currentUser?.photoURL,
      'name': _auth.currentUser?.displayName,
      'email': _auth.currentUser?.email
    }); // 이거 Future<Void>
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            children: [
              //프로필이미지
              const SizedBox(height: 30,),
              const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/프로필이미지.png'),),
              const SizedBox(
                height: 10,
              ),

              //로그인 시도
              TextButton(
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom:
                        3, // This can be the space you need between text and underline
                  ),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.black45,
                    width: 0.8, // This would be the width of the underline
                  ))),
                  child: const Text(
                    '로그인을 해 주세요',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                onPressed: () async {
                  // await signInWithGoogle();
                  await signInWithGoogle();
                  const Page5();
                },
              ),

              const SizedBox(
                height: 30,
              ),

              //아래 세 아이콘
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MainIcon(text: '좋아요 한\n전시', icon: "assets/onheart.svg"),
                  MainIcon(text: '보고 온\n전시', icon: "assets/oncheck.svg"),
                  MainIcon(text: '스크랩한\n칼럼', icon: "assets/onscrap.svg")
                ],
              )
            ],
      ),
    );
  }
}

//아이콘 리팩토링
class MainIcon extends StatelessWidget {
  MainIcon({required this.text, this.icon});

  String text;
  dynamic icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            width: 30,
            height: 30,
            color: Colors.black,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
          )
        ],
      ),
      onTap: () {
        needLoginDialog(context);
      },
    );
  }
}
