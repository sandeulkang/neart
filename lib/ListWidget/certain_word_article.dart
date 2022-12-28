import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neart/Model/model_article.dart';
import '../Lab/article_screen.dart';

//popularexhibit 레이아웃처럼 옆으로 넘어가게.. 하고
//검색바 아래에 나오는 exhibit은 아래로 내려가는 것이고 검색어 따라 stful이므로 클래스 재활용 불가능하다
//이건 stl로 만들고

class CertainWordArticle extends StatelessWidget {
  final String word;

  CertainWordArticle({required this.word});

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Column').snapshots(),
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
    return
    CarouselSlider(
          // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
          items: searchResults
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
        child: Container(
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
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
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
