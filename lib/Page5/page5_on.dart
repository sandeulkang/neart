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
                                                if (value.length > 9) {
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
                                where: const ScrapeScreen()),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: TextButton(
                                child: const Text('Logout'),
                                onPressed: () async {
                                  await _auth.signOut(); //disconnect는 계정 삭제다
                                  setState(() {});
                                })),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: TextButton(
                                child: const Text('전시 write'),
                                onPressed: () async {
                                  FirebaseFirestore
                                      .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                      .collection('placeinfo')
                                      .doc('문화역서울284')
                                      .set({
                                    'info': '휴관일 : 월요일',
                                    'info2':
                                        '주소 : 서울 중구 통일로 1 문화역서울284, 서울역 2번 출구에서 65m\n운영 시간 : 11:00-17:00\n -입장 마감 시간 : 18시 30분 \n관람료 : 무료\n 연락처 : 0507-1416-3501 \n*보다 자세한 사항은 공식 사이트를 확인해 주세요.',
                                  });

                                  FirebaseFirestore
                                      .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                      .collection('exhibition')
                                      .doc('2023 뉴트로 페스티벌 "오늘전통"')
                                      .set({
                                    'title': '2023 뉴트로 페스티벌 "오늘전통"',
                                    'admission': '무료',
                                    'place': '문화역서울284',
                                    'date': '01.19.-02.26.',
                                    'explanation':
                                        '인공지능과 로봇에 대한 의존도가 높아지고 메타버스 세계와 버추얼 아바타의 등장이 더 이상 새롭지 않은 2023년, 전통문화를 돌아보고 이를 계승하는 흐름에 주목하는 <2023 뉴트로 페스티벌 “오늘전통”>을 엽니다. 전통문화의 새로운 오늘을 소개하는 <2023 뉴트로 페스티벌 “오늘전통”>은 올해를 첫 시작으로 앞으로 매년 새해의 시작을 여는 연례행사로 개최될 예정입니다.\n\n새로운 유행이 빠르게 돌고 도는 현대 사회지만 여전히 과거에서 비롯된 우리 문화는 의식과 행동 양식을 규정합니다. 농사를 지었던 옛사람들이 고안한 24절기를 다 기억하지 못하더라도,동지에는 팥죽, 입춘에는 현관에 붙이는 입춘방을 자연스럽게 떠올립니다. 명절에는 가족들과 둘러앉아 윷놀이를 하고, 특별한 날에는 정갈하게 한복을 차려입기도 합니다. 세대에서 세대로 이어지는 전통문화로 인해 한 사회의 정체성이 유지됩니다. .\n\n지키고 가꾸어야 할 전통문화이지만 이를 계승하는 행위는 전통을 그대로 따르는 답습과 구분되어야 합니다. 과거에 계속해서 멈춰 있는 전통은 오늘날 현대인들의 공감을 사기 어려운 탓에 한순간에 잊히기 마련입니다. .\n\n역사가 아놀드 토인비는 문명을 항구가 아닌 항해라고 정의합니다. 전통문화 또한 과거 어느 한 지점에 머물러 있는 형태가 아니라 현재의 시선에서 창조적인 해석을 거치면서 앞으로 계속해서 나아갑니다. 이에 문화체육관광부와 한국공예·디자인문화진흥원은 한지, 한복, 한식, 전통놀이 등 전통생활문화를 오늘날의 관점으로 재해석해 보급 및 활성화에 힘쓰고 있습니다. 이번 전시는 그동안 수행한 여러 사업의 결과물을 한 자리에서 선보이는 자리입니다. 동시에 전통문화를 미래 세대에게 오래도록 전하기 위해 우리의 역할은 무엇인지 질문을 던지고자 합니다. .\n\n전시 주제인 ‘오래오래’에는 과거에서 현재로 이어지는 전통문화가 미래에도 계속해서 이어지길 바라는 마음이 담겨 있습니다. ‘건강하게’, ‘아름답게’, ‘쓸모 있게’, ‘생동하게’, ‘행복하게’라는 각 섹션의 명칭은 전시 내용을 설명하는 것인 한편, 전통문화를 향유하는 모든 이들에게 전달하고자 하는 가치를 의미합니다. 모쪼록 이번 전시를 시작으로 건강하고 행복한 희망으로 가득한 한 해를 맞이하기를 바랍니다. .\n\n.\n\n출처 : 문화역 서울 284 공식 홈페이지',
                                    'keyword': '전통',
                                    'poster':
                                        'https://www.seoul284.org/jnrepo/upload/editor/202301/193824eb1cae41c9ade9a75020b66097_1673319452671.jpg',
                                    'time': FieldValue.serverTimestamp(),
                                  });
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
