import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Model/model_exhibitions.dart';
import '../DetailscreenFolder/detail_screen.dart';

class LikeScreen extends StatefulWidget {
  // *상태 관리 및 상태 선언
  _LikeScreenState createState() => _LikeScreenState();
}

// * StreamBuilder를 통해 영화 데이터 가져옴.
class _LikeScreenState extends State<LikeScreen> {
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('exhibition')
          // * where를 통해 like:true인 데이터를 가져오라는 쿼리문 작성
          .where('bookmark', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        // * 데이터가 있는 경우와 없는 경우로 나눠서 처리
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Expanded(
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.9,
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          // * map 함수를 통해 snapshot 데이터를 하나씩 처리함
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList()),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) { //그리드뷰에 들어갈 아이템
    final exhibition = Exhibition.fromSnapshot(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Image.network(exhibition.poster),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return DetailScreen(exhibition: exhibition);
            }));
          },
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exhibition.title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(exhibition.place),
              const SizedBox(height: 2),
              Text(exhibition.date),
            ],
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false, //축소시 상단에 AppBar가 고정되는지 설정
            expandedHeight: 50, //헤더의 최대 높이
            flexibleSpace: FlexibleSpaceBar(
              //늘어나는 영역의 UI 정의
              title: Text(
                '내가 좋아요 한 전시',
                style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SliverFillRemaining(
              //내용 영역
              child: _buildBody(context))
        ],
      ),
    );
  }
}
