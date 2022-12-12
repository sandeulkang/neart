import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neart/DetailscreenFolder/recommend_column.dart';
import 'package:neart/DetailscreenFolder/together_exhibit.dart';
import 'package:neart/Lab/review_screen.dart';
import '../Model/model_exhibitions.dart';
import 'main_info.dart';

class DetailScreen extends StatefulWidget {
  final Exhibition exhibition;

  DetailScreen({required this.exhibition});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var placeinformation = '';
  var placeinformation2 = '';

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  // 아이디 생성할 때 review, heart, havebeen 이라는 하위 컬렉션도 생성되게 만들어야 함\
  // 컬렉션 생성할 때는 첫번째 문서(doc)도 생성해주어야 함

  void asyncInitState() async {
    DocumentSnapshot placeinfodata = await firebaseFirestore
        .collection('placeinfo')
        .doc(widget.exhibition.place)
        .get(); //placeinfodata는
    // 여기보면 알 수 있다시피 get한 documentsnapshot에서 바로 map []찾을 수 있음, 물론 하나의 doc일 때 편하게 쓸 수 있는 거겠지?
    // 이걸로 listview를 만든다든지 할 거면 당연히 for 반복문이 필요할 것임
    placeinformation = placeinfodata['info'];
    placeinformation2 = placeinfodata['info2'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: false,
            expandedHeight: 35,
            backgroundColor: Colors.white,
          ),
          SliverFillRemaining(
            //내용 영역
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(15))),
                    height: 220,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.network(widget.exhibition.poster),
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                          Container(
                            height: 210,
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.exhibition.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.exhibition.date,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.exhibition.place,
                                ),
                                const SizedBox(height: 1),
                                Text(placeinformation,
                                    style: const TextStyle(height: 1.5)),
                                const SizedBox(height: 1),
                                Text(
                                    widget.exhibition.admission
                                        .replaceAll("\\n", "\n"),
                                    style: const TextStyle(height: 1.5)),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore
                                          .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                          .collection('member')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.email)
                                          .collection('heart')
                                          .doc(widget.exhibition.title)
                                          .get(), //이자식이 heartdoc
                                      builder: (context, snapshot) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            snapshot.data!
                                                    .exists //heartdoc.exists() //data가 텅 빈 것이 아닌, null로서 들어오는 경우 hasData는 true를 반환한다.
                                                ? InkWell(
                                                    //맞으면
                                                    //true 일 때 결과
                                                    child: SvgPicture.asset(
                                                      "assets/onheart.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.red,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        FirebaseFirestore
                                                            .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                                            .collection(
                                                                'member')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.email)
                                                            .collection('heart')
                                                            .doc(widget
                                                                .exhibition
                                                                .title)
                                                            .delete();
                                                        //정상적으로 삭제된다. 그런데 왜 하트가 변하지 않을까?
                                                        //futurebuilder는 future를 한 번만 데려와서?
                                                        //근데 setState 하면 이 클래스가 다시 그려지면서
                                                        //futurebuilder 가 한 번 더 그려지잖아 그럼 바뀐 상태로 다시 그려져야 되는 거 아닌가?
                                                      });
                                                    },
                                                  )
                                                : InkWell(
                                                    child: SvgPicture.asset(
                                                      "assets/offheart.svg",
                                                      width: 40,
                                                      height: 40,
                                                      color: Colors.red,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        FirebaseFirestore
                                                            .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                                            .collection(
                                                                'member')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                ?.email)
                                                            .collection('heart')
                                                            .doc(widget
                                                                .exhibition
                                                                .title)
                                                            .set({
                                                          'heart': 'on'
                                                        });
                                                      });
                                                    },
                                                  ),


                                          ],
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                            bottom: Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 21, 18, 23),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '전시 소개',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          Text(
                            widget.exhibition.explanation
                                .replaceAll("\\n", "\n"),
                            style: const TextStyle(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                            top: Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 21, 18, 23),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '추천 칼럼',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          RecommendColumn(keyword: widget.exhibition.keyword),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                            top: Radius.circular(15))),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 21, 18, 23),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: widget.exhibition.place,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: '에서 진행 중인',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              TogetherExhibit(exhibition: widget.exhibition),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                '운영 정보 확인',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              Text(placeinformation2.replaceAll("\\n", "\n"),
                                  style: const TextStyle(
                                    height: 1.5,
                                  ))
                            ])),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                            top: Radius.circular(15))),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 21, 18, 23),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '후기',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              RecommendColumn(
                                  keyword: widget.exhibition.keyword),
                            ])),
                  )
                ],
              ),
            ),
          ),
        ],
      ),

//        appBar: AppBar(),
    );
  }
}
