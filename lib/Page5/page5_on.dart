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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Column(
                        children: [
                          //유저 프로필 이미지
                          const SizedBox(height: 30),
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
                                                    if (!_tryValidation())
                                                      return;
                                                    setState(
                                                      () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'member')
                                                            .doc(_auth
                                                                .currentUser!
                                                                .email!)
                                                            .update({
                                                          'name': nameController
                                                              .text,
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
                                                decoration:
                                                    const InputDecoration(
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

                          // Padding(
                          //     padding: const EdgeInsets.symmetric(vertical: 50),
                          //     child: TextButton(
                          //         child: const Text('전시 write'),
                          //         onPressed: () async {
                          //           FirebaseFirestore
                          //               .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                          //               .collection('placeinfo')
                          //               .doc('국립현대미술관 과천')
                          //               .set({
                          //             'info': '휴관일 : 월요일',
                          //             'info2':
                          //                 '주소 : 경기 과천시 광명로 313 국립현대미술관\n운영 시간 : 10:00-18:00\n -입장 마감 시간 : 18시 30분 \n관람료 : 상설전 무료, 기획전 변동\n 연락처 : 02-2188-6000 \n*지하철 4호선 서울대공원역 4번출구에서 20분 간격으로 왕복버스 운행. \n*보다 자세한 사항은 공식 사이트를 확인해 주세요.',
                          //           });
                          //
                          //           FirebaseFirestore
                          //               .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                          //               .collection('exhibition')
                          //               .doc('MMCA 예술놀이마당')
                          //               .set({
                          //             'title': 'MMCA 예술놀이마당',
                          //             'admission': '무료',
                          //             'place': '국립현대미술관 과천',
                          //             'date': '12.28.-10.31.',
                          //             'explanation':
                          //                 '어린이미술관의 기능을 강화하고 과천관을 가족 중심 미술관으로 특화하기 위해 시작된 «MMCA예술놀이마당»은 ‘예술·자연·놀이’를 주제로 과천관 안과 밖을 연결하는 프로젝트이다.\n2022년 «MMCA 예술놀이마당»에서는 현대 미술 작가들의 시선으로 바라본 과천-미술관 풍경을 실감형 콘텐츠로 만날 수 있다. 미술관과 자연을 소재로 제작된 실감형 콘텐츠는 디지털 매체를 적극적으로 활용하여 어린이·가족 관람객의 미술관교육 경험 확장이 가능하도록 하고, 감각을 활용한 놀이적 접근으로 어린이들에게 예술 기반의 몰입과 창의적 경험을 유도한다. \n‹미술관 풍경›은 작가의 시선으로 사진 안에 담은 미술관 바깥 풍경을 미술관 안과 연결하며 자연이라는 시간 속에서 축적된 이미지를 콜라주한 작품이다. 이번 전시에서는 어린이미술관과 작가가 협업하여 자연을 주제로 한 사진과 영상, 체험형 인터랙티브 아트 등을 선보인다. \n‘빛·바람·흙·나무·도토리·은행’ 등 작품 속 다양한 자연물을 통해 관람객들은 자연의 법칙이 시간의 흐름에 따라 순환하고 있는 미술관 풍경을 볼 수 있다. 올해 두 번째로 기획된 «MMCA 예술놀이마당»에서 예술, 자연, 놀이가 있는 미술관을 경험하길 바란다. \n\n김태동, ‹미술관 풍경›, 2022, 사진 꼴라쥬, 작가소장\n‹미술관 풍경›은 김태동 작가의 시선으로 사진 안에 담은 미술관 바깥 풍경을 미술관 안과 자연스럽게 연결하며 자연이라는 시간 속에서 축적된 이미지들을 콜라주한 작업이다. 미술관 바깥의 풍경이 사진이라는 이미지를 통해 밀집되어 나타나며, 사진 작가가 어떤 시간의 풍경을 담아내느냐에 따라 다양한 해석이 가능하다. 작가는 어린이들에게 익숙하지만 낯선 풍경, 미술관과 함께 공존하면서도 분리된 미술관 풍경을 주목하게 한다. 자연과 풍경은 김태동 작가의 작업으로 미술관의 안과 밖을 연결하는 매개체로서 이미지화되어 우리에게 소개된다. 빛, 바람, 흙, 나무, 열매, 씨앗 등 작품 속 다양한 소재들은 자연의 법칙이 시간의 흐름에 따라 순환하고 있음을 보여 준다. 이 작품은 미술관 풍경을 시간대별로 촬영한 40여 장의 사진을 다시 대형 사진으로 조합·설치하여 참여자들에게 국립현대미술관 과천관의 자연과 풍경을 감상하도록 한다. \n\n프로그램\n미술관 풍경 놀이\n낙엽 모으기, 도토리 줍기, 은행 찾기\n자연 속 미술관인 국립현대미술관 과천을 배경으로 한 참여형 인터랙티브 아트를 경험할 수 있다. \n움직임이 인식되는 화면 속에서 어린이들은 손으로 낙엽을 모으고 도토리를 줍는 등 다양한 움직임 활동을 통해 체험할 수 있다. \n\n미술관 풍경 만들기\n나의 이야기가 담긴 ‘미술관 풍경을 만들고 표현해 볼 수 있으며, 작가와 나의 ‘미술관 풍경’을 연결하고, 우리들의 ‘미술관 풍경’을 만들 수 있다. \n\n미술관 풍경 퍼즐 놀이\n‹미술관 풍경›을 감상하고 퍼즐을 맞춰 볼 수 있다. \n\n',
                          //             'keyword': '어린이/과천',
                          //             'poster':
                          //                 'https://postfiles.pstatic.net/MjAyMzAyMDNfMjEw/MDAxNjc1NDAxOTA3NjY3.DKUo1S4xzJGTy4fCxl4lvm2pbCk_fq3xf8fyNXiMH4Mg.mtpDC3AF9j0fgmGGgqJ59HJi9tojfyW88_bziqJmYeYg.PNG.tksemf0628/%ED%99%94%EB%A9%B4_%EC%BA%A1%EC%B2%98_2023-02-03_142417.png?type=w773',
                          //             'time': FieldValue.serverTimestamp(),
                          //           });
                          //
                          //         }))
                        ],
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                          child: Container(
                            width: 75,
                            height: 23,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black38))),
                            child: Center(
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                            ),
                          ),
                          onTap: () async {
                            await _auth.signOut(); //disconnect는 계정 삭제다
                            setState(() {});
                          }),
                    ),
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
