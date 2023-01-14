import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/model_exhibitions.dart';
import '../Review/one_review_screen.dart';

class CheckedScreen2 extends StatelessWidget {

  var reviews;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('review')
            .where("writeremail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .orderBy('time', descending: true)
            .get(),
        builder: (context,snapshot){
          // Text(snapshot.data!.docs[1]['writeremail']);
        if(!snapshot.hasData){return const LinearProgressIndicator();}
        return
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length, //문제는 snapshot.data.docs가 되느냐 즉 널에도 docs가 되는냐 length는 null에 못하는데
            itemBuilder: (context, i){
              reviews=snapshot.data!.docs;
              if(reviews.isEmpty){return const Center(child: Text('아직 작성하신 리뷰가 없어요!'));}
              return
                Padding( //이 전 부터 문제임
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child:
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return OneReviewScreen(reviewdoc: reviews[i]['writeremail']+reviews[i]['exhibitiontitle']);
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
                          FutureBuilder<Exhibition>(
                              future: getExhibitRef(reviews[i]),
                              builder: (context, exhibition){
                                var Date = DateFormat('yyyy.MM.dd').format((reviews[i]['time'] as Timestamp).toDate());
                                if(!exhibition.hasData){return const SizedBox(width: 1,);}
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width:30,
                                            child: Image.network(exhibition.data!.poster)),
                                        SizedBox(width:10),
                                        Text(exhibition.data!.title),
                                      ],
                                    ),
                                    Text(Date,style: TextStyle(fontSize: 10),)
                                  ],
                                );
                              }),
                          const Divider(
                            height: 20,
                          ),
                          Text(reviews[i]['content'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11),),
                        ],
                      ),
                    ),
                  ),
                );
            }
        );
        }
    );
  }
}

Future<Exhibition> getExhibitRef (DocumentSnapshot review) async{
//내가 하려는 짓 : 들어온 하나의 review의 ref에 들어가 그
  var ref;
  var docu;
  var exhibition;

  ref = await review['exhibitref'];
  docu = await ref.get();
  exhibition = Exhibition.fromSnapshot(docu);

  return exhibition;
}

