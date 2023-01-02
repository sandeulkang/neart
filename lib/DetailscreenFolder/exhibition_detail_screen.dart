import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neart/DetailscreenFolder/recommend_column.dart';
import 'package:neart/DetailscreenFolder/together_exhibit.dart';
import 'package:neart/ListWidget/certain_reviews_screen.dart';
import 'package:neart/Review/writing_screen.dart';
import '../Review/revise_screen.dart';
import '../Model/model_exhibitions.dart';

class ExhibitionDetailScreen extends StatefulWidget {
  final Exhibition exhibition;

  ExhibitionDetailScreen({required this.exhibition});

  @override
  State<ExhibitionDetailScreen> createState() =>
      _ExhibitionDetailScreenState();
}

class _ExhibitionDetailScreenState extends State<ExhibitionDetailScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var placeinformation = '';
  var placeinformation2 = '';

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    DocumentSnapshot placeinfodata = await firebaseFirestore
        .collection('placeinfo')
        .doc(widget.exhibition.place)
        .get();
    //placeinfodata는
    // 여기보면 알 수 있다시피 get한 documentsnapshot에서 바로 map []찾을 수 있음, 물론 하나의 doc일 때 편하게 쓸 수 있는 거겠지?
    // 이걸로 listview를 만든다든지 할 거면 당연히 for 반복문이 필요할 것임
    placeinformation = await placeinfodata['info'];
    placeinformation2 = await placeinfodata['info2'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebebeb),
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
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore
                          .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                          .collection('member')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .collection('havebeen')
                          .doc(widget.exhibition.title)
                          .get(),
                      builder: (context, havebeen) {
                        if (!havebeen.hasData)
                          return const SizedBox(
                            width: 1,
                          );
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15))),
                          height: havebeen.data!.exists ? 290 : 220,
                          //height 설정 안 하면 어떻게 되는지 확인
                          //너무 tight한 게 문제라면 패딩이나 margin값 주면 되니까
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height: 195,
                                      child: Image.network(
                                          widget.exhibition.poster),
                                    ),
                                    Container(
                                      // height: 230,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            style:
                                            const TextStyle(fontSize: 13),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            widget.exhibition.place,
                                          ),
                                          const SizedBox(height: 1),
                                          Text(placeinformation,
                                              style:
                                              const TextStyle(height: 1.5)),
                                          const SizedBox(height: 1),
                                          Text(
                                              widget.exhibition.admission
                                                  .replaceAll("\\n", "\n"),
                                              style:
                                              const TextStyle(height: 1.5)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: FutureBuilder<
                                                      DocumentSnapshot>(
                                                      future: FirebaseFirestore
                                                          .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                                          .collection('member')
                                                          .doc(FirebaseAuth
                                                          .instance
                                                          .currentUser
                                                          ?.email)
                                                          .collection('heart')
                                                          .doc(widget
                                                          .exhibition.title)
                                                          .get(),
                                                      builder:
                                                          (context, heart) {
                                                        if (!heart.hasData) {
                                                          return const SizedBox(
                                                              width: 1);
                                                        }
                                                        return heart.data!
                                                            .exists //heartdoc.exists() //data가 텅 빈 것이 아닌, null로서 들어오는 경우 hasData는 true를 반환한다.
                                                            ? InkWell(
                                                          //맞으면
                                                          //true 일 때 결과
                                                          child:
                                                          SvgPicture
                                                              .asset(
                                                            "assets/onheart.svg",
                                                            width: 40,
                                                            height: 40,
                                                            color: Colors
                                                                .red,
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
                                                                  .collection(
                                                                  'heart')
                                                                  .doc(widget
                                                                  .exhibition
                                                                  .title)
                                                                  .delete();
                                                            });
                                                          },
                                                        )
                                                            : InkWell(
                                                          child:
                                                          SvgPicture
                                                              .asset(
                                                            "assets/offheart.svg",
                                                            width: 40,
                                                            height: 40,
                                                            color: Colors
                                                                .red,
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
                                                                  .collection(
                                                                  'heart')
                                                                  .doc(widget
                                                                  .exhibition
                                                                  .title)
                                                                  .set({
                                                                'heart':
                                                                'on'
                                                              });
                                                            });
                                                          },
                                                        );
                                                      }),
                                                ),
                                                Expanded(
                                                    child: havebeen.data!
                                                        .exists //heartdoc.exists() //data가 텅 빈 것이 아닌, null로서 들어오는 경우 hasData는 true를 반환한다.
                                                        ? InkWell(
                                                      //맞으면
                                                      //true 일 때 결과
                                                      child: SvgPicture
                                                          .asset(
                                                        "assets/oncheck.svg",
                                                        width: 40,
                                                        height: 40,
                                                        color:
                                                        Colors.black,
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
                                                              .collection(
                                                              'havebeen')
                                                              .doc(widget
                                                              .exhibition
                                                              .title)
                                                              .delete();
                                                        });
                                                      },
                                                    )
                                                        : InkWell(
                                                      child: SvgPicture
                                                          .asset(
                                                        "assets/offcheck.svg",
                                                        width: 40,
                                                        height: 40,
                                                        color:
                                                        Colors.black,
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
                                                              .collection(
                                                              'havebeen')
                                                              .doc(widget
                                                              .exhibition
                                                              .title)
                                                              .set({
                                                            'havebeen':
                                                            'on'
                                                          });
                                                        });
                                                      },
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: havebeen.data!.exists,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 80,
                                    child: FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore
                                            .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
                                            .collection('review')
                                            .doc(FirebaseAuth.instance.currentUser!.email!+widget.exhibition.title)
                                            .get(),
                                        builder: (context, reviewsnapshot) {
                                          if (!reviewsnapshot.hasData) {
                                            return const SizedBox(width: 1);
                                          }
                                          return reviewsnapshot.data!.exists
                                              ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReviseScreen(
                                                              exhibition:
                                                              widget
                                                                  .exhibition)));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets
                                                  .fromLTRB(20, 0, 20, 0),
                                              margin: const EdgeInsets
                                                  .fromLTRB(10, 0, 10, 0),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                    Colors.black38),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    30),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  reviewsnapshot.data!['content'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                            ),
                                          )
                                              : GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WritingScreen(
                                                              exhibition:
                                                              widget
                                                                  .exhibition)));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                    Colors.black38),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    30),
                                              ),
                                              margin: const EdgeInsets
                                                  .fromLTRB(10, 0, 10, 0),
                                              height: 50,
                                              child: const Center(
                                                child: Text(
                                                    '클릭하여 리뷰를 적어보세요!'),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
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
                    height: 10,
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
                    height: 10,
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
                  const SizedBox(height: 10),
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
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              CertainReviewsScreen(title: widget.exhibition.title),
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
