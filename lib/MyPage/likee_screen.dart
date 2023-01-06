import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/model_exhibitions.dart';

class LikeeScreen extends StatelessWidget {
  const LikeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('heart')
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('noDATA');
          return _fromhearttoref(context, snapshot.data!.docs);
        });
  }
}


Widget _fromhearttoref(BuildContext context, List<DocumentSnapshot> snapshot) {

  List<DocumentSnapshot> abc = [];

  for (int i = 0; i < snapshot.length; i++) {
    abc.add(snapshot[i]['ref']);
  }
  //아 snapshot[i]['ref']가 DocumentSnapshot이 아닌 JsonDocumentReference타입이래
  //정확히는 전달과정에서 ㅇㅇ 근데 전달이 안된ㅅ ㅏㅇ태에서 사용하려니
  //Jsondocumentreference 상태인 거고, 근데 요구하는 건 DocumentReference고

  print(abc);

  return Container();

  // return _buildList(context, abc);

}

//지금 이거 위에서 아래로 넘어가는 리스트가
//ref(heart의 ref라는 필드)의 컬렉션이어야 하는데 heart의 컬렉션임

//heart collection을 가져온다
//각각의 문서의 ref를 가져온다 = 즉 얘를 리스트로 만들어야 함

//각각의 문서의 ref를 사용한다(얘를 Gridview의 낱개로 만들어서 반복하면 되겠지)

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  // return GridView.builder(
  //     padding: const EdgeInsets.fromLTRB(15, 5, 13, 0),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         mainAxisSpacing: 5, //수평 Padding
  //         crossAxisSpacing: 1,
  //         childAspectRatio: 0.5),
  //     itemCount: snapshot.length, //이거 exhibition.length로 바꿔도 ㄱㅊ나 봐보
  //     itemBuilder: (BuildContext context, int i) {
  //       List<Exhibition> exhibitions =
  //           snapshot.map((data) => Exhibition.fromSnapshot(data)).toList();
  //       //  List<Exhibition> exhibitions = snapshot.map((data) => Exhibition.fromSnapshot(data)).toList();
  //       // //exhibitions 라는 리스트는 들어온 snapshot이라는 list 안의 map들을 Exhibition화 시켜준 리스트이다.
  //       // final exhibition = Exhibition.fromSnapshot(data);
  //
  //       return Column(
  //         children: [
  //           SizedBox(
  //             height: 250,
  //             width: 180,
  //             child: Image.network(
  //               exhibitions[i].poster,
  //               fit: BoxFit.fitHeight,
  //             ),
  //           ),
  //         ],
  //       );
  //     });
  return(Text('hi'));
}
