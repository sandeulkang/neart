import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'kakaologin/kakao_login.dart';
import 'kakaologin/main_view_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LABLAB extends StatefulWidget {
  const LABLAB({Key? key}) : super(key: key);

  @override
  State<LABLAB> createState() => _LABLABState();
}

class _LABLABState extends State<LABLAB> {
  final viewModel = MainViewModel(KakaoLogin());
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

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
                  backgroundImage: NetworkImage(viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? 'https://postfiles.pstatic.net/MjAyMjExMjdfMTIw/MDAxNjY5NTUxMjg2OTQ4.LRuMV7Ike0UJuxyqAcxuFQ-W5DNkTcmziHjVnRAlbMEg.O-qz3HVtnQmNABwzqk-cWW93XSXTPbCt4U0FbZmLp5Ig.PNG.tksemf0628/%ED%94%84%EB%A1%9C%ED%95%84%EC%9D%B4%EB%AF%B8%EC%A7%80.png?type=w773'),
                ),
                SizedBox(
                  height: 10,
                ),
                GoogleSignInAccount != null
                ? Text("Logined",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                )
                : TextButton(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: 3, // This can be the space you need between text and underline
                    ),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(
                          color: Colors.black45,
                          width: 0.8, // This would be the width of the underline
                        ))
                    ),
                    child: Text('로그인해 주세요',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await viewModel.login();
                    setState(() {});
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
                      onTap: () {},
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
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: () async {
                    await viewModel.logout();
                    setState(() {});
                  },
                  child: const Text('Logout'),
                ),
                ElevatedButton(
                  onPressed: () {GoogleSignIn().signIn(); setState(() {
                  });},
                  child: const Text('GoogleLogin'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
