import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neart/Review/one_review_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'certain_word_exhibit.dart';
import 'package:neart/Model/model_article.dart';
import '../Model/model_review.dart';

class Page1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('요즘 인기있는 전시',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10,),
          CertainWordExhibit(word: '인기'),
          MainText(text: '지금 뜨고 있는 키워드 #인천'),
          CertainWordExhibit(word: '인천'),
          MainText(text: '최근 올라온 리뷰'),
          recentReview(),
          MainText(text: '곧 끝나는 전시',),
          CertainWordExhibit(word: '곧 끝나는'),
          MainText(text: '아트 칼럼',),
          recentArtColumn(),
        ],
      ),
    );
  }
}

//////////////////여기 비효율적일 수도 있겠단 생각이 든다

//recent ArtColumn 위젯의 future method
Future getArticleData() async {
  QuerySnapshot a = await FirebaseFirestore.instance
      .collection('Column')
      .orderBy('time', descending: true)
      .limit(4)
      .get(); //Querysnapshot<Map<... 타입이다
  List<Article> articles = a.docs.map((d) => Article.fromSnapshot(d)).toList();

  return articles;
}

//recent ArtColumn 위젯
Widget recentArtColumn() {
  return FutureBuilder(
    future: getArticleData(), //
    builder: (BuildContext context, AsyncSnapshot articles) {
      if (!articles.hasData)
      {return const SizedBox(
        width: 1,
      );}
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: articles.data!.length,
          itemBuilder: (BuildContext context, i) {
            return
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () async{
                    final url = Uri.parse(articles.data![i].url);
                    if (await canLaunchUrl(url)) {
                      launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        articles.data![i].poster,
                        height: 80,
                        width: MediaQuery.of(context).size.width*0.23,//110
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.65,
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
                    ],
                  ),
                ),
              );
          });
    },
  );
}


//recentreview 위젯의 future method
Future getReviewData() async {
  QuerySnapshot a = await FirebaseFirestore.instance
      .collection('review')
      .orderBy('time', descending: true)
      .limit(3)
      .get(); //Querysnapshot<Map<... 타입이다
  List<Review> reviews = a.docs.map((d) => Review.fromSnapshot(d)).toList();

  return reviews;
}

//recentReview 위젯
Widget recentReview() {
  return FutureBuilder(
    future: getReviewData(), //
    builder: (BuildContext context, AsyncSnapshot reviews) {
      if (!reviews.hasData)
      {return const SizedBox(
        width: 1,
      );}
      return ListView.builder(
          itemCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, i) {
            return
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return OneReviewScreen(reviewdata: reviews.data![i]);
                          //여기서 onereviewscreen이 안에서 futurebuilder를 사용하면
                          //불러왔던 리뷰의 문서를 괜히 또 읽게 되는 것이다 읽기 비용이 더 들게 된다
                          //위젯으로 바꿔서, 즉 플러 내에서 사용한 맵으로 바꾸어서 보내자 모든 원리뷰스크린을 위젯화하자
                        },
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff6f6f6),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
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
                              {return const SizedBox(
                                width: 1,
                              );}
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
          });
    },
  );
}

//메인 텍스트 리팩토링
class MainText extends StatelessWidget{
  MainText({required this.text});

  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
      child: Text(text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}
