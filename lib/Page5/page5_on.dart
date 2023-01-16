import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'MyPage/checked_screen.dart';
import 'MyPage/like_screen.dart';
import 'MyPage/scrapped_article_screen.dart';

class Page5_on extends StatefulWidget {
  const Page5_on({Key? key}) : super(key: key);

  @override
  State<Page5_on> createState() => _Page5_onState();
}

class _Page5_onState extends State<Page5_on> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController nameController;
  final _formKey = GlobalKey<FormState>();

  bool _tryValidation() {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
    return isValid;
  }

  //프로필 이미지 변경
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
        .child(_auth.currentUser!.email!); //child()에서 괄호 안에 입력된 값이 파일 이름이다

    //ref에 파일을 넣었다. 스토리지에 현 user의 email의 이름으로 프로필사진이 갱신된다.
    await ref.putFile(File(image!.path));

    //ref의 url(즉 갱신된 프로필 사진의 url)을 불러오고 그걸 파이어스토어 user의 profileUrl에 넣어준다. 정확히는 갱신인데, 없으면 만들어진다.
    ref.getDownloadURL().then((value) {
      setState(() {
        FirebaseFirestore.instance
            .collection('member')
            .doc(_auth.currentUser!.email!)
            .update({'profileUrl': value});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('member')
                .doc(_auth.currentUser!.email!)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                nameController =
                    TextEditingController(text: snapshot.data!['name']);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        //유저 프로필 이미지
                        Stack(clipBehavior: Clip.none, children: [
                          CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(snapshot.data?[
                                  'profileUrl']) //image.network하면 안 되고 networkimage해야 됨
                              ),
                          Positioned(
                              left: 87,
                              top: 87,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.black45,
                                child: IconButton(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                  iconSize: 20,
                                  color: Colors.white,
                                ),
                              ))
                        ]),
                        const SizedBox(
                          height: 15,
                        ),

                        // 유저 닉네임, 닉네임 변경
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Opacity(
                              opacity: 0,
                              child: SizedBox(
                                width: 24,
                              ),
                            ),
                            Text(
                              snapshot.data!['name'],
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Stack(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              child: const Text(
                                                '취소',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            const SizedBox(width: 90),
                                            TextButton(
                                                child: const Text(
                                                  '설정',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  if (!_tryValidation()) return;
                                                  setState(
                                                    () {
                                                      FirebaseFirestore.instance
                                                          .collection('member')
                                                          .doc(_auth
                                                              .currentUser!
                                                              .email!)
                                                          .update({
                                                        'name':
                                                            nameController.text,
                                                      });
                                                    },
                                                  );
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        ),
                                        Dialog(
                                          backgroundColor: Colors.white,
                                          child: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              controller: nameController,
                                              textAlign: TextAlign.center,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return '한 글자 이상 입력해 주세요.';
                                                }
                                                if (value!.length>9){
                                                  return '닉네임은 최대 아홉 글자예요.';
                                                }
                                                return null;
                                              },
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                  filled: false),
                                            ),
                                          ),
                                        ),
                                      ]);
                                    });
                              },
                              child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black45,
                                  child: Image.asset('assets/pen.png',
                                      height: 17)),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),

                        //아래 세 아이콘
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MainIcon(
                                text: '좋아요 한\n전시',
                                icon: "assets/onheart.svg",
                                where: const LikeScreen()),
                            MainIcon(
                                text: '보고 온\n전시',
                                icon: "assets/oncheck.svg",
                                where: CheckedScreen()),
                            MainIcon(
                                text: '스크랩한\n칼럼',
                                icon: "assets/onscrap.svg",
                                where: ScrapeScreen()),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child: TextButton(child: Text('Logout'),
                              onPressed: () async {
                                await _auth.signOut(); //disconnect는 계정 삭제다
                                setState(() {});
                              }))
                      ],
                    )
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

// 아이콘 리팩토링
class MainIcon extends StatelessWidget {
  MainIcon({required this.text, this.icon, this.where});

  String text;
  dynamic icon;
  dynamic where;

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
        Navigator.push(context, MaterialPageRoute(builder: (context) => where));
      },
    );
  }
}
