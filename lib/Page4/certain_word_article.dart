import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Model/model_article.dart';
import '../trash/article_screen.dart';

class CertainWordArticle extends StatelessWidget {
  final String word;

  CertainWordArticle({required this.word});

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('Column').where('keyword', arrayContains: word).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    // * listView 생성
    return
    CarouselSlider(
          // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
          items: snapshot
              .map((data) => _buildListItem(context, data))
              .toList(),
      options: CarouselOptions(autoPlay: true, viewportFraction: 0.9, aspectRatio: 2.8), );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final article = Article.fromSnapshot(data);
    // * 각각을 누를 수 있도록 InkWell() 사용
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                // * 클릭한 영화의 DetailScreen 출력
                return ArticleScreen(article: article);
              },
            ),
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.9,
          height: MediaQuery.of(context).size.width*0.9*0.3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                article.poster,
                height: 80,
                width: 120,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                width: MediaQuery.of(context).size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      article.content,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}

