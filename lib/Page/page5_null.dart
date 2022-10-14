import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:neart/Page/page5.dart';
import 'package:neart/authenticationpage.dart';

class Page5_null extends StatelessWidget {
  const Page5_null({Key? key}) : super(key: key);

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
                  backgroundImage: AssetImage('assets/프로필이미지.png'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: 3, // This can be the space you need between text and underline
                      ),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0, // This would be the width of the underline
                          ))
                      ),
                      child: Text('로그인해 주세요.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  onPressed: (){Navigator.pushNamed(context, "/Authentication");},
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
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              'the Others',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 50,
            ),
            IconButton(
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  Page5();
                },
                icon: Icon(Icons.logout, size: 80)),
          ],
        ),
      ),
    );
  }
}
