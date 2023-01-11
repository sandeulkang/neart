import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neart/MyPage/like_screen.dart';

import '../MyPage/checked_screen.dart';

class Page5_on extends StatefulWidget {
  const Page5_on({Key? key}) : super(key: key);

  @override
  State<Page5_on> createState() => _Page5_onState();
}

class _Page5_onState extends State<Page5_on> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //FirebaseAuth.instance 계속 쳐주기 귀찮으니까~~~!
  late TextEditingController nameController;
  final _formKey = GlobalKey<FormState>();

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  Future pickImage() async {
    //먼 미래에 pickImage가 실행됐을 때~
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      maxWidth: 400,
      imageQuality: 75,
    );

    //불러온 사진을 넣을 스토리지 변수 ref 를 만들었다. storage file(?) 타입이다. 현 user의 email의 이름의 파일을 불러오는데, 없다면 생성된다.
    final ref = await FirebaseStorage.instance.ref().child(FirebaseAuth
        .instance.currentUser!.email!); //child()에서 괄호 안에 입력된 값이 파일 이름이다

    //ref에 파일을 넣었다. 스토리지에 현 user의 email의 이름으로 프로필사진이 갱신된다.
    await ref.putFile(File(image!.path));

    //ref의 url(즉 갱신된 프로필 사진의 url)을 불러오고 그걸 파이어스토어 user의 profileUrl에 넣어준다. 정확히는 갱신인데, 없으면 만들어진다.
    ref.getDownloadURL().then((value) {
      setState(() {
        FirebaseFirestore.instance
            .collection('member')
            .doc(_auth.currentUser!.email!)
            .update({'profileUrl': value});
      }); //////////이거 반영이 안 됨
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
              //snapshot이란 들어온 Future의 데이터를 말하는 것. snapshot이 아닌 다른 단어여도 됨
              if (snapshot.hasData == true) {
                nameController =
                    TextEditingController(text: snapshot.data!['name']);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
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
                                  backgroundColor: Colors.black54,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Opacity(
                                child: SizedBox(
                                  width: 24,
                                ),
                                opacity: 0,
                              ),
                              Text(
                                snapshot.data?['name'],
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
                                                    _tryValidation();
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
                                                  return null;
                                                },
                                                // snapshot.data?['name'],
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
                                    backgroundColor: Colors.black54,
                                    child: Image.asset('assets/pen.png',
                                        height: 17)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 35,
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
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '좋아요 한\n전시',
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LikeScreen()));
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
                                    const SizedBox(height: 4),
                                    const Text(
                                      '보고 온\n전시',
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CheckedScreen()));
                                },
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
                                    const SizedBox(height: 4),
                                    const Text(
                                      '스크랩한\n칼럼',
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _auth.signOut(); //disconnect는 계정 삭제다
                              setState(() {});
                            },
                            child: const Text('Logout'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                FirebaseFirestore
                                    .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                    .collection('placeinfo')
                                    .doc('서울시립 북서울미술관')
                                    .set({
                                  'info': '휴관일: 매주 월요일' ,
                                  'info2': '주소 : 서울 노원구 동일로 1238, 하계역 1번 출구에서355m\n운영 시간 : 10:00-20:00 \n-토는 10:00-18:00) \n관람료 : 상설전시 무료, 특별전 유료 \n연락처 : 02-2124-5201 \n*입장 마감시간 평일 19시/주말, 공휴일 17시' ,
                                });
                                FirebaseFirestore
                                    .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                    .collection('placeinfo')
                                    .doc('문화실험공간 호수')
                                    .set({
                                  'info': '휴관일: 없음' ,
                                  'info2': '주소 : 서울 송파구 송파나루길 256, 잠실역 3번 출구에서 289m\n운영 시간 : 09:30-20:00 \n관람료 : 무료\n 연락처 : 0507-1326-9784 ' ,
                                });

                                // FirebaseFirestore
                                //     .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                //     .collection('exhibition')
                                //     .doc('키키 스미스 : 자유낙하')
                                //     .set({
                                //   'title': '키키 스미스 : 자유낙하' ,
                                //   'admission': '무료' ,
                                //   'date': '12.15.-03.12.',
                                //   'explanation':'《키키 스미스  ― 자유낙하》는 신체에 대한 해체적인 표현으로 1980-1990년대 미국 현대미술사에서 독자적인 영역을 구축해 온 키키 스미스의 아시아 첫 미술관 개인전입니다. 1994년에 제작된 작품 제목이기도 한 ‘자유낙하’는 스미스의 작품에 내재한 분출과 생동의 에너지를 의미하며, 여성 중심 서사를 넘어 범문화적인 초월 서사를 구사하는 작가의 지난 40여 년간의 방대한 작품활동을 한데 묶는 연결점으로 기능합니다. 또한 파편화된 신체를 탐구하는 스미스의 역동성을 상징하는 한편, 달이 지구를 맴도는 자유낙하 운동처럼 배회를 통해 매체와 개념을 확장해 온 작가의 수행적 태도를 동시에 담아냅니다. 이번 전시에서는 이러한 특징에 기초하여 조각, 판화, 사진, 드로잉, 태피스트리, 아티스트북 등 140여 점에 이르는 작품을 소개합니다.\n키키 스미스가 예술에 입문하기 시작한 1980년대 미국은 에이즈, 임신중절 등을 둘러싼 이슈를 필두로 신체에 대한 인식이 두드러지는 시기였습니다. 이 당시 스미스는 아버지와 여동생의 죽음까지 차례로 겪으면서 생명의 취약함과 불완전함에 대해 숙고하게 됩니다. 이러한 일련의 배경은 해부학에 대한 개인적인 관심사와 맞물리면서 스미스가 신체의 안과 밖을 집요하게 오가며 탐구하는 계기를 이루게 됩니다. 분절되고 파편화된 인체 표현과 더불어 생리혈, 땀, 눈물, 정액, 소변 등 신체 분비물과 배설물까지 가감없이 다루면서 신체에의 비위계적 태도를 취한 스미스는 1990년대 미국의 애브젝트 아트를 대표하는 작가로도 설명됩니다. 나아가 2000년대 이후부터는 동물, 자연, 우주 등 주제와 매체를 점차 확장하여 현재까지도 경계에 구분이 없는 비선형적 서사를 구사해오고 있습니다. \n작가는 자신이 신체에 관심을 두게 된 이유가 단순히 여성성을 새로운 방식으로 해석하거나 부각시키기 위함이 아니라 신체야말로 “우리 모두가 공유하는 형태이자 각자의 경험을 담을 수 있는 그릇”이기 때문이라고 말했는데, 이러한 다층적 해석이 이번 전시의 중요한 출발점이 되었습니다. 전시는 작가의 초기작부터 근작에 이르기까지 작품에서 일관되게 발견되는 서사구조, 반복성, 에너지라는 요소를 기반으로, 서로 느슨하게 연결된 세 가지 주제인 ‘이야기의 조건: 너머의 내러티브’, ‘배회하는 자아’, ‘자유낙하: 생동하는 에너지’를 제안합니다. \n스미스는 본인의 예술 활동을 일종의 ‘정원 거닐기’라 칭했습니다. 이는 여러 매체와 개념을 맴돌며 경계선 언저리에서 사유하는 배회의 움직임에 대한 상징이기도 합니다. 그리고 이러한 움직임은 소외되거나 보잘것없는, 혹은 아직 닿지 않은 모든 생명에 대한 경의의 메세지를 담아 오늘도 작품으로 여실히 옮겨지고 있습니다. 1980-1990년대를 거쳐 현재에 이르기까지 시대의 굴곡을 유영해 온 스미스는 “나는 여전히 자유낙하 중이다.”라고 말합니다. 느리고 긴 호흡으로 주변의 ‘크고 작은 모든 생명’에 귀 기울이며 상생의 메시지를 던지는 스미스의 태도야말로 과잉, 범람, 초과와 같은 수식어가 익숙한 오늘날 다시 주목해야 할 가치일 것입니다. ',
                                //   'keyword': '기획전/조각/판화/사진/태피스트/아티스트북',
                                //   'poster': 'https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F5851%2F2022%2F12%2F19%2F0000002118_001_20221219152804028.jpg&type=sc960_832',
                                //   'place': '서울시립 북서울미술관',
                                //   'time': FieldValue.serverTimestamp(),
                                // });
                              });
                            },
                            child: const Text('전시 write'),
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
