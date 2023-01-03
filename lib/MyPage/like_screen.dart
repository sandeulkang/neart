import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//
class LikeScreen extends StatelessWidget {
  const LikeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('heart')
            .get(),
        //doc[0].title-> 리스트에 하나하나 넣기 ex. List = [1,2,3,4] -> 전체 리스트
        //Futurebuilder로 불러오기. 전시 제목이 1인 doc 2인 doc 3인 doc 하나하나 ㅇㅇ
        //결국은 for i 구문 이용해서 doc(List[i]).get 이렇게.. 하나하나 리스트뷰 모듈을 만들어나간다 (listview.builder) 이용
        //아니면 하나하나 불러와서 doc(List[i]).get 해서 이걸 다 리스트에 넣고.. 리스트뷰빌더에 리스트로서 전달하든지
        //아니면 바로 snapshot.data!.docs[i]
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }
          return Container();
        });
  }
}
