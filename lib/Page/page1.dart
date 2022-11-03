import 'package:flutter/material.dart';
import 'package:neart/Model/model_exhibitions.dart';
import 'package:neart/trash/Listvew_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Lab/certain_word_article_list.dart';
import '../Lab/certain_word_exhibit.dart';
import '../Lab/review_screen.dart';

class Ppage1 extends StatefulWidget {
  @override
  State<Ppage1> createState() => _Ppage1State();
}

class _Ppage1State extends State<Ppage1> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = firebaseFirestore.collection('exhibition').snapshots();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: streamData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Some error occured: ${snapshot.error.toString()}'),
          );
        }
        if (snapshot.hasData) {
          return _buildBody(context, snapshot.data!.docs); //snapshot 전체를 다루는 게 아니라 snapshot.data!.docs만 국한적으로 다룸
        }
        return LinearProgressIndicator();}
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    //실제적으로 movie들의 '리스트'가 생겨나는 타이밍
    List<Exhibition> exhibitions = snapshot.map((d) => Exhibition.fromSnapshot(d)).toList();
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
          SizedBox(height: 40,),
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
          Container(child: Reviews(), height: 200,),
          const SizedBox(
            height: 10,
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
          CertainWordArticleList(word:""),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}



// const Text(
// '분야별 전시', //종류? 장르?
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
// ),
// const SizedBox(height: 10),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// mainAxisSize: MainAxisSize.max,
// children: [
// CircleButton(
// onTap: () {},
// text: '평면',
// child: Image.asset("assets/에곤실레.jpg"),
// ),
// CircleButton(
// onTap: () {},
// text: '영상',
// child: Image.asset("assets/영상.png"),
// ),
// CircleButton(
// onTap: () {},
// text: '입체',
// child: Image.asset("assets/조각.jpg"),
// ),
// CircleButton(
// onTap: () {},
// text: '체험',
// child: Image.asset("assets/체험.jpg"),
// ),
// CircleButton(
// onTap: () {},
// text: '대학',
// child: Image.asset("assets/대하.jpg"),
// ),
// ],
// ),

//서클 버튼 만들기
// class CircleButton extends StatelessWidget {
//   CircleButton({
//     //생성자를 한번 적어주고 가야한다. 여기서 기본값 지정 가능. 아래에 변수를 먼저 만들어주고 생성자를 적어주어야 당연히 에러가 안나겠지!
//     Key? key,
//     this.onTap,
//     this.child,
//     this.width,
//     this.height,
//     this.text,
//   }) : super(key: key);
//
//   dynamic onTap; //final로 하면 Prefer typing uninitialized variables and fields.이라는 경고가 떠서 dynamic으로 함
//   dynamic child; //근데 dynamic으로 하면 This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final: 어쩌고 경고 뜸
//   dynamic width;
//   dynamic height;
//   dynamic text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           child: SizedBox(
//             width: 50,
//             height: 50,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(100),
//               child: child,
//             ),
//           ),
//           onTap: () {
//             if (onTap != null) onTap();
//           },
//         ),
//         const SizedBox(
//           height: 7,
//         ),
//         Text('$text'),
//       ],
//     );
//   }
// }