import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neart/Page/page5.dart';
import 'package:neart/authenticationpage.dart';
import 'package:flutterfire_ui/auth.dart';

class Page5_on extends StatefulWidget {
  const Page5_on({Key? key}) : super(key: key);

  @override
  State<Page5_on> createState() => _Page5_onState();
}

class _Page5_onState extends State<Page5_on> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/프로필이미지.png'),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 250,
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'FirebaseAuth.instance.currentUser.email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
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
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              'the Others',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
                IconButton(
                    onPressed: () async{
                      await FirebaseAuth.instance.signOut();
                      Page5();
                    },
                    icon: Icon(Icons.logout, size: 80)),
          ])),
    );
  }
}

