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
import '../Model/model_user.dart';

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


  } //현재 로그인한 유저의 email을 member의 email로 등록하게 함 근데 이러면 매번 갱신됨 씹;; 어카노

  File? image;
  String imageUrl = " ";

  var userData = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .get();
  //.get()이 아닌 .snapshot()을 하면 doc전체의 흐름이 불러와진다. 실질적인 data가 아니라 ㅇㅇ 그리고 get()으로 불러와지는 data는 map형태일 것이다


  Future pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 400,
      imageQuality: 75,
    );

    final ref = FirebaseStorage.instance
        .ref()
        .child(FirebaseAuth.instance.currentUser!.email!);
    //없으면 만듦 ㅇㅇ 걱정 ㄴㄴ

    await ref.putFile(File(image!.path)); //userId를 가진
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
        FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.email!)
            .update(
                {'profileUrl': imageUrl}); //imageurl 지우고 value로 바로 가능한지 테스트 해보기
        //update안 하고 set 하면 기존의 field인 email은 지워짐 안 ㅣㅈ워지게 하려면 여기서 email도 다시 set해줘야되는 거 ㅇㅇ
      });
    });
  }

  Widget _buildBody(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      // FireStore 인스턴스의 exhibition 컬렉션의 snapshot을 가져옴
      stream: FirebaseFirestore.instance.collection('member').where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!).snapshots(),
      builder: (context, snapshot) {
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _build(context, snapshot.data!.docs);
      },
    );
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
                imageUrl == ""
                    ? Stack(children: [
                        CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                // NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!) 지금photourl없어서 안됨
                                AssetImage('assets/프로필이미지.png')
                            //안되면 child를 backgroundimage로
                            ),
                        Positioned(
                          left: 70,
                          top: 70,
                          child: InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Image.asset(
                              'assets/추가 버튼.png',
                              height: 25,
                              width: 25,
                            ),
                          ),
                        )
                      ])
                    : Stack(children: [
                        CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                imageUrl) //image.network하면 안 되고 networkimage해야 됨
                            //imageUrl 대신 현재 로그인한 사람의 firebasefirestoredb에 'member'컬렉션에 현재 email docs에 'photourl' field 값 불러오기
                            ),
                        Positioned(
                          left: 70,
                          top: 70,
                          child: InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Image.asset(
                              'assets/추가 버튼.png',
                              height: 25,
                              width: 25,
                            ),
                          ),
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
                            color: Colors.black87,
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
