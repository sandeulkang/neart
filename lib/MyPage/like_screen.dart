import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//
class LikeScreen extends StatelessWidget {
  const LikeScreen({Key? key}) : super(key: key);

  //doc[0].title-> 리스트에 하나하나 넣기 ex. List = [1,2,3,4] -> 전체 리스트
  //Futurebuilder로 불러오기. 전시 제목이 1인 doc 2인 doc 3인 doc 하나하나 ㅇㅇ
  //결국은 for i 구문 이용해서 doc(List[i]).get 이렇게.. 하나하나 리스트뷰 모듈을 만들어나간다 (listview.builder) 이용

  //아니면 하나하나 불러와서 doc(List[i]).get 해서 이걸 다 리스트에 넣고.. 리스트뷰빌더에 리스트로서 전달하든지

  //아니면 바로 doc(snapshot.data!.docs[i].title)해서 리스트뷰화 하든가.....
  //즉 하트한 '타이틀'을 리스트로(하나하나 for i해서) 만들고나서 그걸 다시 for i해서 전시 doc을 하나씩 가져오든가

  //아니면 하트한 타이틀을 for i 해서 가져오면서 바로 그걸 전시 doc가져오게 하든가
  //타이틀 가져오기/리스트뷰 만들기 -> 이 둘을 하나 끝내고 하나 할래 아니면 동시에 할래 이거임
  //아니면 데이터 구조를 이렇게 바꾸는 건 어떨까 exhibition doc에 또 heart collection을 새로 만드는 거야
  //아니면 데이터 구조를 이렇게 바꾸는 건 ㅓㅇ떨까 exhibition doc에 heart라는 새로운 field를 추가하고 계속 업데이트 하는 거야(어레이든, field든) 근데 그럼 지우는 게 너무 번거롭겠다

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('heart')
            .doc('threedimentionalwarmth')
            .get(),
        builder: (context, docref) {
          if (!docref.hasData) {
            return const Text('데이터없음');
          }
          return FutureBuilder(
              future: docref.data!['ref'].get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> exhibitref) {
                if (exhibitref.hasData) {
                  return Text(exhibitref.data!['title']);
                }
                return Text('aa');
              });
        });
  }
}
