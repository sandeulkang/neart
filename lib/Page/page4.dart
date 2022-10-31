import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:neart/Model/model_exhibitions.dart';
import 'package:neart/trash/Listvew_builder.dart';
import 'package:neart/trash/box_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../DetailscreenFolder/detail_screen.dart';
import '../Lab/certain_word_article.dart';

//stl로 해도 되겠는데? 아니다 검색어 입력해서 사용자 상태 기억해야되니까 stful해야된다
class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // late Stream<QuerySnapshot> streamData;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   streamData = firebaseFirestore.collection('Column').snapshots();
  // }
  //
  // Widget _fetchData(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: streamData,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return Center(
  //             child: Text('Some error occured: ${snapshot.error.toString()}'),
  //           );
  //         }
  //         if (snapshot.hasData) {
  //           return _buildBody(context, snapshot.data!
  //               .docs); //snapshot 전체를 다루는 게 아니라 snapshot.data!.docs만 국한적으로 다룸
  //         }
  //         return LinearProgressIndicator();
  //       }
  //   );
  // }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('지금 조회수 높은 칼럼',style:TextStyle(fontSize: 18, fontWeight: FontWeight.w800),),
              CertainWordArticle(word:"인기"),
              //서치 바에 따른 listview 빌더 말고 ~ .count(?)

            ])
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
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