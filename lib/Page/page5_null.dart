import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neart/Page/page5.dart';
import 'package:neart/authenticationpage.dart';

class Page5_null extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = await GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _auth.signInWithCredential(credential);
    //여기서 구글 로그인의 계정은 바로 _auth.currentUser로 사용 가능한 듯 하다
    //여전히 구글로그인이라는 시스템과 연결이 되어 있는 듯 하다 그러니 photoURL이라는 것을 사용할 수 있는 거겠지


    //구글 auth에 등록된 이미지를 스토리지에 저장해서(pickimage 참고) 다시 그걸 파이어베이스의 email의 profile url 필드 생성하여 넣기
    // Once signed in, return the UserCredential
    return await FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set({'profileUrl': _auth.currentUser?.photoURL,
    'name' : _auth.currentUser?.email,
    'email' : _auth.currentUser?.email}); // 이거 Future<Void>

  }

  void showPopup(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {

          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          return Dialog(
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Center(child: Text('로그인이 필요한 서비스입니다.',style: TextStyle(fontSize: 16),)),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://postfiles.pstatic.net/MjAyMjExMjdfMTIw/MDAxNjY5NTUxMjg2OTQ4.LRuMV7Ike0UJuxyqAcxuFQ-W5DNkTcmziHjVnRAlbMEg.O-qz3HVtnQmNABwzqk-cWW93XSXTPbCt4U0FbZmLp5Ig.PNG.tksemf0628/%ED%94%84%EB%A1%9C%ED%95%84%EC%9D%B4%EB%AF%B8%EC%A7%80.png?type=w773'
                    )),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom:
                      3, // This can be the space you need between text and underline
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black45,
                              width:
                              0.8, // This would be the width of the underline
                            ))),
                    child: Text(
                      '로그인을 해 주세요',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    // await signInWithGoogle();
                    await signInWithGoogle();
                    Page5();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/onheart.svg",
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '좋아요 한\n전시',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      onTap: () {showPopup(context);},
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/oncheck.svg",
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '보고 온\n전시',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      onTap: () {showPopup(context);},
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/onscrap.svg",
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '스크랩한\n칼럼',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      onTap: () {showPopup(context);},
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
