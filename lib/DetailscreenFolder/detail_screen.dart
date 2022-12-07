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

  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool heart = false;
  bool havebeen = false;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var placeinformation = '';
  var placeinformation2 = '';

  @override
  void initState() {
    super.initState();
    heart = widget.exhibition.heart;
    havebeen = widget.exhibition.havebeen;
    asyncInitState();
  }

  void asyncInitState() async {
    DocumentSnapshot placeinfodata = await firebaseFirestore
        .collection('placeinfo')
        .doc(widget.exhibition.place)
        .get(); //placeinfodata는
    setState(() {
      // 여기보면 알 수 있다시피 get한 documentsnapshot에서 바로 map []찾을 수 있음, 물론 하나의 doc일 때 편하게 쓸 수 있는 거겠지?
      // 이걸로 listview를 만든다든지 할 거면 당연히 for 반복문이 필요할 것임
      placeinformation = placeinfodata['info'];
      placeinformation2 = placeinfodata['info2'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 35,
          ),
          SliverFillRemaining(
            //내용 영역
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     left: 10,
                  //   ),
                  //   child:
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                      height: 250,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.network(widget.exhibition.poster),
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                          Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width * 0.6,
                            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.exhibition.title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  widget.exhibition.date,
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.exhibition.place,
                                ),
                                SizedBox(height: 1),
                                Text(placeinformation.replaceAll("\\n", "\n"),
                                    style: TextStyle(height: 1.5)),
                                SizedBox(height: 1),
                                Text(
                                    widget.exhibition.admission
                                        .replaceAll("\\n", "\n"),
                                    style: TextStyle(height: 1.5)),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      FirebaseAuth.instance.currentUser != null
                                          ? InkWell(
                                              child:
                                              FirebaseAuth.instance.currentUser != null
                                    ?SvgPicture.asset(
                                                "assets/onheart.svg",
                                                width: 40,
                                                height: 40,
                                                color: Colors.red,
                                              )
                                              :SvgPicture.asset(
                                "assets/onheart.svg",
                                width: 40,
                                height: 40,
                                color: Colors.red,
                                ),
                                              onTap: () {
                                                setState(() {
                                                  heart = !heart;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({'heart': heart});
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
                                                  heart = !heart;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({'heart': heart});
                                                });
                                              },
                                            ),
                                      havebeen
                                          ? InkWell(
                                              child: SvgPicture.asset(
                                                "assets/oncheck.svg",
                                                width: 40,
                                                height: 40,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  havebeen = !havebeen;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({
                                                    'havebeen': havebeen
                                                  });
                                                });
                                              },
                                            )
                                          : InkWell(
                                              child: SvgPicture.asset(
                                                "assets/off_check.svg",
                                                width: 40,
                                                height: 40,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  havebeen = !havebeen;
                                                  firebaseFirestore
                                                      .collection('exhibition')
                                                      .doc(widget
                                                          .exhibition.title)
                                                      .update({
                                                    'havebeen': havebeen
                                                  });
                                                });
                                                print('daf');
                                              },
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // ),
                  Opacity(
                    child: Divider(
                      height: 20,
                      thickness: 10,
                    ),
                    opacity: 0.4,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,15,15,20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '전시 소개',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          widget.exhibition.explanation.replaceAll("\\n", "\n"),
                          style: TextStyle(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  Opacity(
                    child: Divider(
                      height: 20,
                      thickness: 10,
                    ),
                    opacity: 0.4,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,15,15,20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '추천 칼럼',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RecommendColumn(keyword: widget.exhibition.keyword),
                      ],
                    ),
                  ),
                  Opacity(
                    child: Divider(
                      height: 20,
                      thickness: 10,
                    ),
                    opacity: 0.4,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(15,15,15,20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: widget.exhibition.place,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '에서 진행 중인',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TogetherExhibit(exhibition: widget.exhibition),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '운영 정보 확인',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(placeinformation2.replaceAll("\\n", "\n"),
                                style: TextStyle(
                                  height: 1.5,
                                ))
                          ])),
                  Opacity(
                    child: Divider(
                      height: 20,
                      thickness: 10,
                    ),
                    opacity: 0.4,
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(15,15,15,20),
                      child: Column(children: [
                        Text(
                          '감상평',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        )
                      ]))
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
