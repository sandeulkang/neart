import 'package:flutter/material.dart';
import 'package:neart/Model/model_exhibitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Lab/article_screen.dart';
import '../ListWidget/certain_word_exhibit.dart';
import '../ListWidget/certain_reviews_screen.dart';
import 'package:neart/Model/model_article.dart';

class Ppage1 extends StatelessWidget {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firebaseFirestore.collection('exhibition').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occured: ${snapshot.error.toString()}'),
            );
          }
          if (snapshot.hasData) {
            return _buildBody(
                context,
                snapshot.data!
                    .docs); //snapshot 전체를 다루는 게 아니라 snapshot.data!.docs만 국한적으로 다룸
          }
          return const LinearProgressIndicator();
        });
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    //실제적으로 exhibition들의 '리스트'가 생겨나는 타이밍
    List<Exhibition> exhibitions =
        snapshot.map((d) => Exhibition.fromSnapshot(d)).toList();
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
          SizedBox(
            // child: Reviews(title: ),
            height: 200,
          ),
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
          blabla(),],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}

Future getData() async {
  QuerySnapshot b = await FirebaseFirestore.instance
      .collection('Column')
      .orderBy('time', descending: true)
      .limit(4)
      .get(); //Querysnapshot<Map<... 타입이다
  List<QueryDocumentSnapshot> a = b.docs;
  //b 뒤에 바로 .docs 붙여주면 The getter 'docs' isn't defined for the type 'Future<QuerySnapshot<Map<String, dynamic>>>'.
  //라는 에러가 뜬다. await을 붙여줬다 해도 그 안에서는 아직 진행상태이니 당연히 future로 자기들끼리 인식한다.
  //docs는 await가 끝난, future가 확실히 아닌 친구 뒤에 붙일 수 있는 것이다.
  List<Article> articles = a.map((d) => Article.fromSnapshot(d)).toList();

  return articles;
}

Widget blabla() {
  return FutureBuilder(
    future: getData(), //
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return SizedBox(
        height: 420,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemCount: snapshot.data!.length, //data 뒤에 ! 붙이면 null check on nullablevalue라는 에러뜸
            itemBuilder: (BuildContext context, index) {
              return
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          // * 클릭한 영화의 DetailScreen 출력
                          return ArticleScreen(article: snapshot.data![index]);
                        },
                      ),
                    );
                  },
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          snapshot.data![index].poster,
                          height: 80,
                          width: 110,
                        ),
                        Expanded(
                          flex:5,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                    snapshot.data![index].content,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(fontSize:11)
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