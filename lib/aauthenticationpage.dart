import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class LABLAB extends StatefulWidget {
  const LABLAB({Key? key}) : super(key: key);

  @override
  State<LABLAB> createState() => _LABLABState();
}

//setState 안 하고 streambuilder 쓰는 방법
//streambuilder 안 쓰고 로그인 버튼 클릭하고 나면 setstate 하는 방법(그러므로 stful위젯 써야됨)
// 둘 중 뭘 쓰든 userdata == true(?) : ? 해서 삼항 연산 해줘야 하는 건 같다
//streambuilder는 일부분만 리셋되고 setState은 전체가 리셋된다
//streambuilder가 호출을 대기한다고 해서 그게 속도에 영향을 미치는 건 아니니 streambuilder가 나을 듯 하다 라고 하기에는 로그인 하면 달라지는 것들이 많으니까...
//깔끔하게 setState 한방으로 끝내자 ㅋ
//라고 하기에 setState 으로 하면 데이터가 불러와지ㅣ기 전에 setState 돼 버릴 위험이 있음


class _LABLABState extends State<LABLAB> {

  final FirebaseAuth _auth = FirebaseAuth.instance; //FirebaseAuth.instance 계속 쳐주기 귀찮으니까~~~!

  var userDoc = FirebaseFirestore.instance
      .collection('member')
      .doc(FirebaseAuth.instance.currentUser!.email!);

  Future<DocumentSnapshot> userData = FirebaseFirestore.instance
      .collection('member')
      .doc(FirebaseAuth.instance.currentUser!.email!).get();

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      ''
                          )),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'a',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/onheart.svg",
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '좋아요 한\n전시',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/oncheck.svg",
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '보고 온\n전시',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/onscrap.svg",
                            width: 30,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '스크랩한\n칼럼',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut(); //disconnect는 계정 삭제다
                    setState(() {
                    });
                  },
                  child: const Text('Logout'),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}
