import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:neart/Model/model_exhibitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../DetailscreenFolder/exhibition_detail_screen.dart';
import '../Lab/article_screen.dart';
import '../ListWidget/certain_word_article.dart';
import '../Model/model_article.dart';

//stl로 해도 되겠는데? 아니다 검색어 입력해서 사용자 상태 기억해야되니까 stful해야된다
class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _Page4State() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    streamData = firebaseFirestore.collection('Column').snapshots();
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Column')
          .orderBy('time', descending: true)
          .snapshots(), //QuerySnapshot 타입임
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(
      BuildContext context, List<QueryDocumentSnapshot> snapshot) {
    List<QueryDocumentSnapshot> searchResults = [];

    for (QueryDocumentSnapshot d in snapshot) {
      // *string.contains()를 활용해 searchText를 포함한 snapshot을 리스트에 추가
      // * 주의!) data.toString()해도 실행은 되지만 검색 결과가 안 나옴!
      if (d.data().toString().contains(_searchText)) {
        //여기서는 Exhibition.toString에 포함된(즉 $title,keyword에 포함되어있나를 살펴보는 것 같다)
        searchResults.add(d); //이로써 searchResults는 선별되어진 docs 들로 구성된 list이다
      }
    }

    return Container(
      child: ListView( //리스트 뷰와 싱글찰드스크롤뷰 안에서 for i 로 칼럼 찰드 만드는 거의 차이가 뭐일지
        physics :NeverScrollableScrollPhysics(), //shinkwraptrue만 하고 이거 안 하면 안 돼요~
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(3),
        // * map()함수를 통해 각 아이템을 buildListItem 함수로 넣고 호출
        children:
            searchResults.map((data) => _buildListItem(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final article = Article.fromSnapshot(data);
    // * 각각을 누를 수 있도록 InkWell() 사용
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                height: 80,
                width: 110,
              ),
              Expanded(
                flex:5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        article.content,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize:11)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '지금 조회수 높은 칼럼',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            CertainWordArticle(word: "인기"),
            Container(
              height: 60,
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 6, // 취소 떴을 때 검색칸과 취소의 비율
                    // * 검색 입력 필드 만들기
                    child: TextField(
                      focusNode: focusNode,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      autofocus: false,
                      controller: _filter,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: '키워드를 검색해 보세요!',
                        labelStyle: TextStyle(color: Colors.black),
                        // * 검색창 디자인
                        filled: true,
                        fillColor: Colors.white54,
                        // * 좌측 아이콘 추가
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black38,
                          size: 20,
                        ),
                        // * 우측 아이콘 추가
                        suffixIcon: focusNode.hasFocus
                            ? IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.black38,
                                  size: 20,
                                ),
                                // * cancle 아이콘 누르면 _filter와 _searchText 초기화
                                onPressed: () {
                                  setState(() {
                                    _filter.clear();
                                    _searchText = "";
                                  });
                                },
                              )
                            : Container(),
                        // * 검색창 디자인(테두리, 테두리 색상 등)
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                  ),
                  // * 검색바 클릭시 취소 버튼 생겼다가 취소 누르면 없어지게 만들기
                  focusNode.hasFocus
                      ? Expanded(
                          child: TextButton(
                            child: Text(
                              "취소",
                              style: TextStyle(color: Colors.black38),
                            ),
                            onPressed: () {
                              setState(() {
                                _filter.clear();
                                _searchText = "";
                                focusNode.unfocus();
                              });
                            },
                          ),
                        )
                      : Expanded(
                          flex: 0,
                          child: Container(),
                        )
                ],
              ),
            ),
            //서치 바에 따른 listview 빌더 말고 ~ .count(?)
            _buildBody(context) // 얘 하면 certainwordarticle 스크롤이 안 됨
          ],
        ),
      ),
    );
  }
}

//서버 데이터 필요하므로 stful위젯 써야 하고 파이어스토어에서 칼럼이 업데이트 되는 대로 로드해야 되니까 streambuilder 써야 함
// 이걸 stream으로 삼고 timestamp순으로 나열하고,
//특정 query불러와서 클릭수 높은 칼럼에 배치
//서치하는 용어 따라 검색이 되어야 하는데
//page2같은 경우 위에 검색바가 고정임... 이거의 경우 그 위에 있는 클릭수높은 칼럼까지 고정일 것이니 page2그대로 따라해서는 안됨
//page1처럼 구조화하면 되지 안흥ㄹ까? 요즘 인기있는 전시에 클릭수 높은 칼럼을 하고
//그 아래 지금 뜨고 있는 키워드 부분을 listview.builder로 아래로 스크롤 되게 하면 됨 그리고 스트림은 이거 안에서만 쓰면 됨
//page2에서 listviewbuilder가 화면 전체를 차지할 수 밖에 없었는데 여기서도 그러려나?\
//page2에서 실험을 해보자 listview builder 위에 뭔가를 만들어서 응 안됨 그래도 여기서 함 해보자!!!
//근데 거기서 검색창이 있고 바로바로 구현되는 게 과연 보기가 좋을까? 그럼요 시발 내가 못할뿐
//아마 page1은 되고 page2는 안되는게 page1은 안에 .builder인 위젯이 없기 때문일 거임
