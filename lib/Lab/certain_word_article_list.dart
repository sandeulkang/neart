import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Model/model_article.dart';
import 'article_screen.dart';


class CertainWordArticleList extends StatelessWidget {
  final String word;

  CertainWordArticleList({required this.word});

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Column')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // snapshot의 데이터가 없는 경우 Linear~ 생성
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> searchResults = [];
    // *데이터에 searchText가 포함되는지 필터링 진행
    for (DocumentSnapshot d in snapshot) {
      if (d.data().toString().contains(word)) {
        searchResults.add(d);
      }
    }

    // * listView 생성
    return Container(
      height: 500,
      child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(3),
            // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
            children: searchResults
                .map((data) => _buildListItem(context, data))
                .toList()
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final article = Article.fromSnapshot(data);
    // * 각각을 누를 수 있도록 InkWell() 사용
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
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
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                article.poster,
                height: 100,
                width: 130,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
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