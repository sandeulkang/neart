import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neart/Lab/like_screen.dart';
import 'package:neart/Page/page5.dart';
import 'package:neart/Page/page5_null.dart';
import 'package:neart/authenticationpage.dart';
import 'package:flutterfire_ui/auth.dart';

class Page5_on extends StatefulWidget {
  Page5_on({Key? key}) : super(key: key);

  @override
  State<Page5_on> createState() => _Page5_onState();
}

class _Page5_onState extends State<Page5_on> {
  void initState() {
    FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .set({'email': FirebaseAuth.instance.currentUser!.email!});
  }

  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (image == null) return;

      //image는 xFile 타입이고 ㅇ여기에 .path를 붙이고 File로 감싸 imageTemp에 넣어준다. 결국 imageTemp는 File 타입이다

      final imageTemp =
          File(image.path); //imagetemp라는 파이널(변경될수없는) 변수를 만들어 그 file(불특정함)을 넣어줌.

      setState(() {
        // ()=>this.image 구조를 (){this.image...} 구조로 바꿈
        this.image = imageTemp; //그 file을 다시 image에 넣어줌. 한 함수에서 같은 변수가 두 개가 있으면 에러나니 this.붙여서 구분(?)
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
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
                image != null
                    ? Image.file(image!)
                    : Stack(children: [
                        CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                // NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!) 지금photourl없어서 안됨
                                AssetImage('assets/프로필이미지.png')
                            //안되면 child를 backgroundimage로
                            ),
                        Positioned(
                          left: 60,
                          top: 60,
                          child: IconButton(
                              onPressed: () {
                                pickImage();
                              },
                              icon: Icon(Icons.add)),
                        )
                      ]),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
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
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          // * 클릭한 영화의 DetailScreen 출력
                          return LikeScreen(); //navigatior은 그곳으로 이동한다가 개념, build return은 그곳에 그리는 것, 즉 불러 오는 것.
                        }));
                      },
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
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Page5_null();
                },
                icon: Icon(Icons.logout, size: 80)),
          ],
        ),
      ),
    );
  }
}
