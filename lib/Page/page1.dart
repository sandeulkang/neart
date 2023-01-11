import 'package:flutter/material.dart';
import 'package:neart/Model/model_exhibitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neart/Review/one_review_screen.dart';
import '../DetailscreenFolder/exhibition_detail_screen.dart';
import '../Lab/article_screen.dart';
import '../ListWidget/certain_word_exhibit.dart';
import '../ListWidget/certain_reviews_screen.dart';
import 'package:neart/Model/model_article.dart';

import '../Model/model_review.dart';

class Ppage1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '요즘 인기 있는 전시',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          CertainWordExhibit(word: '인기'),
          const SizedBox(
            height: 40,
          ),
          const Text(
            '지금 뜨고 있는 키워드 #인천',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          CertainWordExhibit(word: '인천'),
          const SizedBox(height: 60),
          const Text(
            '최근 올라온 리뷰',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          recentReviewColumn(),
          const SizedBox(
            height: 60,
          ),
          const Text(
            '곧 끝나는 전시',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          CertainWordExhibit(word: '곧 끝나는'),
          const SizedBox(
            height: 60,
          ),
          const Text(
            '아트 칼럼',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 10,
          ),
          recentArtColumn(),
        ],
      ),
    );
  }
}

Future getArticleData() async {
  QuerySnapshot a = await FirebaseFirestore.instance
      .collection('Column')
      .orderBy('time', descending: true)
      .limit(4)
      .get(); //Querysnapshot<Map<... 타입이다
  List<Article> articles = a.docs.map((d) => Article.fromSnapshot(d)).toList();

  return articles;
}

Widget recentArtColumn() {
  return FutureBuilder(
    future: getArticleData(), //
    builder: (BuildContext context, AsyncSnapshot articles) {
      if (!articles.hasData)
        return const SizedBox(
          width: 1,
        );
      return SizedBox(
        height: 420,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemCount: articles.data!.length,
            //data 뒤에 ! 붙이면 null check on nullablevalue라는 에러뜸
            itemBuilder: (BuildContext context, i) {
              return
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            // * 클릭한 영화의 DetailScreen 출력
                            return ArticleScreen(
                                article: articles.data![i]);
                          },
                        ),
                      );
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            articles.data![i].poster,
                            height: 80,
                            width: 110,
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    articles.data![i].title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                      articles.data![i].content,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 11)
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            }),
      );
    },
  );
}


Future getReviewData() async {
  QuerySnapshot a = await FirebaseFirestore.instance
      .collection('review')
      .orderBy('time', descending: true)
      .limit(3)
      .get(); //Querysnapshot<Map<... 타입이다
  List<Review> reviews = a.docs.map((d) => Review.fromSnapshot(d)).toList();

  return reviews;
}

Widget recentReviewColumn() {
  return FutureBuilder(
    future: getReviewData(), //
    builder: (BuildContext context, AsyncSnapshot reviews) {
      if (!reviews.hasData)
        return const SizedBox(
          width: 1,
        );
      return Container(
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // shrinkWrap: true,
            itemCount: reviews.data!.length,
            itemBuilder: (BuildContext context, i) {
              reviews.data![i].exhibitiontitle;

              return
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return OneReviewScreen(reviewdoc: reviews.data![i].writeremail+reviews.data![i].exhibitiontitle);
                              },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xfff6f6f6),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: const EdgeInsets.fromLTRB(10, 15, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder <DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('member')
                                  .doc(reviews.data![i].writeremail)
                                  .get(),
                              builder: (context, usersnapshot) {
                                if (!usersnapshot.hasData)
                                  return const SizedBox(
                                    width: 1,
                                  );
                                return Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                            usersnapshot.data![
                                            'profileUrl']) //image.network하면 안 되고 networkimage해야 됨
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(usersnapshot.data!['name'],),
                                  ],
                                );
                              }
                          ),
                          const Divider(
                            height: 20,
                          ),
                          Text(reviews.data![i].content, maxLines: 2, overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                    ),
                  ),
                );
            }),
      );
    },
  );
}

