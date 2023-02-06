import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neart/DetailscreenFolder/together_exhibit.dart';
import 'package:neart/DetailscreenFolder/certain_reviews_screen.dart';
import 'package:neart/Review/writing_screen.dart';
import '../Model/model_review.dart';
import '../Review/one_review_screen.dart';
import '../Model/model_exhibitions.dart';
import '../needLoginDialog.dart';

class ExhibitionDetailScreen extends StatefulWidget {
  final Exhibition exhibition;

  ExhibitionDetailScreen({required this.exhibition});

  @override
  State<ExhibitionDetailScreen> createState() => _ExhibitionDetailScreenState();
}

class _ExhibitionDetailScreenState extends State<ExhibitionDetailScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final userdoc = FirebaseFirestore.instance
      .collection('member')
      .doc(FirebaseAuth.instance.currentUser?.email);
  var placeinformation = '';
  var placeinformation2 = '';
  Map<String, dynamic> mapdata = {};
  var review;

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    DocumentSnapshot placeinfodata =
    await db.collection('placeinfo').doc(widget.exhibition.place).get();
    placeinformation = await placeinfodata['info'];

  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> mapdata = {
      'title': widget.exhibition.title,
      'ref': db.collection('exhibition').doc(widget.exhibition.title),
      'time': FieldValue.serverTimestamp(),
    };

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //heartdata, havebeendata에 따라 퓨처빌더를 두 개 만들어야 하는데
                  //havebeendata에 따라 상위 컨테이너의 크기가 결정되므로 havebeen 기반으로 하는 퓨처빌더 먼저 불러왔다
                  FutureBuilder<DocumentSnapshot>(
                      future: userdoc
                          .collection('havebeen')
                          .doc(widget.exhibition.title)
                          .get(),
                      builder: (context, havebeen) {
                        if (!havebeen.hasData) {
                          return const SizedBox(
                            width: 1,
                          );
                        }
                        return Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15))),
                          height: havebeen.data!.exists ? 280 : 220,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    height: 195,
                                    child: Image.network(widget.exhibition.poster),
                                  ),
                                  Container(
                                    height: 195,
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    padding: const EdgeInsets.only(left: 12),
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
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                  FutureBuilder<
                                                      DocumentSnapshot>(
                                                      future: userdoc
                                                          .collection('heart')
                                                          .doc(widget.exhibition.title)
                                                          .get(),
                                                      builder:
                                                          (context, heart) {
                                                        if (!heart.hasData) {
                                                          return const SizedBox(
                                                              width: 1);
                                                        }
                                                        return heart.data!.exists
                                                            ? InkWell(
                                                          child: SvgPicture
                                                              .asset(
                                                            "assets/onheart.svg",
                                                            width: 40,
                                                            height: 40,
                                                            color: Colors.red,
                                                          ),
                                                          onTap: () {
                                                            setState(
                                                                    () {
                                                                  userdoc.collection('heart')
                                                                      .doc(widget.exhibition.title)
                                                                      .delete();
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
                                                            FirebaseAuth.instance.currentUser != null
                                                                ? setState(
                                                                    () {
                                                                  userdoc
                                                                      .collection('heart')
                                                                      .doc(widget.exhibition.title)
                                                                      .set(
                                                                      mapdata);
                                                                })
                                                                : needLoginDialog(
                                                                context);
                                                          },
                                                        );
                                                      }),
                                                ),
                                                Expanded(
                                                    child: havebeen.data!.exists
                                                        ? InkWell(
                                                      child: SvgPicture
                                                          .asset(
                                                        "assets/oncheck.svg",
                                                        width: 40,
                                                        height: 40,
                                                        color: Colors.black,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          userdoc.collection('havebeen')
                                                              .doc(widget.exhibition.title)
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
                                                        color: Colors.black,
                                                      ),
                                                      onTap: () {
                                                        FirebaseAuth.instance.currentUser != null
                                                            ? setState(() {
                                                              userdoc.collection('havebeen')
                                                                  .doc(widget.exhibition.title)
                                                                  .set({'poster':widget.exhibition.poster,
                                                                'place':widget.exhibition.place,
                                                                'title': widget.exhibition.title,
                                                                'ref': db.collection('exhibition').doc(widget.exhibition.title),
                                                                'time': FieldValue.serverTimestamp(),
                                                              });
                                                            })
                                                            : needLoginDialog(context);
                                                      },
                                                    )),
                                              ],
                                            ),
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
                                  child: FirebaseAuth.instance.currentUser == null
                                      ? const SizedBox(width: 1)
                                      : StreamBuilder<DocumentSnapshot>(
                                    //얘는 streambuilder필수임 리뷰가 수정, 작성, 삭제 등등 되면 바로 업데이트 되어야 하니까
                                      stream: db.collection('review')
                                          .doc(FirebaseAuth.instance.currentUser!.email! + widget.exhibition.title).snapshots(),
                                      builder: (context, reviewsnapshot) {
                                        if (!reviewsnapshot.hasData) {
                                          return const SizedBox(width: 1);
                                        }
                                        return reviewsnapshot.data!.exists
                                            ? GestureDetector(
                                          onTap: () async {
                                            review = await Review.fromSnapshot(reviewsnapshot.data!);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OneReviewScreen(
                                                            reviewdata:
                                                            review)));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.all(20),
                                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              reviewsnapshot.data!['content'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                            : GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WritingScreen(exhibition: widget.exhibition)));
                                          },
                                              child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38,
                                                  width: 1),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            height: 50,
                                            child: const Center(
                                              child: Text(
                                                '클릭하여 리뷰를 적어보세요!',
                                                style: TextStyle(
                                                    color: Colors.black87),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                  MainContainer(
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
                          widget.exhibition.explanation.replaceAll("\\n", "\n"),
                          style: const TextStyle(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  MainContainer(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: widget.exhibition.place,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: '에서 진행 중인',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          TogetherExhibit(place: widget.exhibition.place),
                          const Text(
                            '운영 정보 확인',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: db.collection('placeinfo').doc(widget.exhibition.place).get(),
                            builder: (context,snapshot) {
                              if(!snapshot.hasData) {return SizedBox(width: 1,);}
                              return Text(snapshot.data!['info2'].replaceAll("\\n", "\n"),
                                  style: const TextStyle(
                                    height: 1.5,
                                  ));
                            }
                          )
                        ]),
                  ),
                  MainContainer(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '후기',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          CertainReviewsScreen(title: widget.exhibition.title),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainContainer extends StatelessWidget {
  MainContainer({required this.child});

  dynamic child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:10),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15), top: Radius.circular(15))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 21, 18, 23), child: child));
  }
}
