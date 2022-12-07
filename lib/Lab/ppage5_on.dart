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
import 'dart:io';

class Ppage5_on extends StatefulWidget {
  const Ppage5_on({Key? key}) : super(key: key);

  @override
  State<Ppage5_on> createState() => _Ppage5_onState();
}

class _Ppage5_onState extends State<Ppage5_on> {

  @override
  initState() {
    userData = FirebaseFirestore.instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.email!).get();
    super.initState();
  }

  var userData;
  var ProfileUrl = "";
  final userQuery = FirebaseFirestore.instance
      .collection('member')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email!);

  Future pickImage() async {
    //먼 미래에 pickImage가 실행됐을 때~
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 400,
      imageQuality: 75,
    );

    //불러온 사진을 넣을 스토리지 변수 ref 를 만들었다. storage file(?) 타입이다. 현 user의 email의 이름의 파일을 불러오는데, 없다면 생성된다.
    final ref = await FirebaseStorage.instance
        .ref()
        .child(FirebaseAuth.instance.currentUser!.email!); //child()에서 괄호 안에 입력된 값이 파일 이름이다

    //ref에 파일을 넣었다. 스토리지에 현 user의 email의 이름으로 프로필사진이 갱신된다.
    await ref.putFile(File(image!.path));

    //ref의 url(즉 갱신된 프로필 사진의 url)을 불러오고 그걸 파이어스토어 user의 profileUrl에 넣어준다. 정확히는 갱신인데, 없으면 만들어진다.
    ref.getDownloadURL().then((value) {
      setState(() {
        FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.email!)
            .update({'profileUrl': value});
        //update안 하고 set 하면 기존의 field인 email은 지워짐 안 ㅣㅈ워지게 하려면 여기서 email도 다시 set해줘야되는 거 ㅇㅇ
      });
    });
  }



  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      // 로그인한 user의 doc의 실시간 흐름을 반영한다. 이 stream이 아직 안들어오면 인디케이터 띄우고 들어오면 scaffold를 띄운다
      stream: userQuery.snapshots(),
      builder: (context, snapshot) {
        userData = FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.email!).get(); //얘 지워도 될 듯
        //map형태의 userData에서 profileUrl이라는 key의 값을 찾으려는데 왜 안 되지? 아마 이게 <future>상태라서 안 되는 것 같다.
        // 문제되는 [] 사용되는 부분이 여기밖에 없음
        setState(() {
          ProfileUrl = userData['profileUrl'];

        });
        if (!snapshot.hasData) return LinearProgressIndicator();
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ProfileUrl == ""
                        ? Stack(children: [
                            //profileurl이 빈값이라면
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
                                    ProfileUrl) //image.network하면 안 되고 networkimage해야 됨
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
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildBody(context)
    ); //scaffold하고 안에 bui
  }
}
