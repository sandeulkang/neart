import 'package:flutter/material.dart';
import 'package:neart/Model/model_exhibitions.dart';
import 'package:neart/Lab/Listvew_builder.dart';
import 'package:neart/Lab/detail_screen.dart';
import 'package:neart/Page/page1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class BoxSlider extends StatefulWidget {
  late final List<Exhibition> exhibitions;
  BoxSlider({required this.exhibitions});

  @override
  State<BoxSlider> createState() => _BoxSliderState();

}

class _BoxSliderState extends State<BoxSlider> {

  late Stream<QuerySnapshot> streamData;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late List<Exhibition> exhibitions;


  @override
  void initState() {
    super.initState();
    exhibitions = widget.exhibitions; //초기값 선언해준거 ㅇㅇ
    // final streamData = firebaseFirestore.collection('exhibition').snapshots(); 없어도 됨
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: makeBoxImages(context, widget.exhibitions),
      ),
    );
  }
}

List<Widget> makeBoxImages(BuildContext context, List<Exhibition> exhibitions) {
  List<Widget> results = [];
  for (var i = 0; i < exhibitions.length; i++) {
    results.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>DetailScreen(exhibition: exhibitions[i])),
              );

              /***
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                  return DetailScreen(
                  exhibition: exhibitions[i],
                  );
                  }));
               ***/
            },

            child: Container(
                height: 350, width: 280,
                child: Image.network(exhibitions[i].poster,fit: BoxFit.fitHeight,),
              ),

          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exhibitions[i].title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),

                ),
                const SizedBox(
                  height: 4,
                ),
                Text(exhibitions[i].place),
                const SizedBox(height: 2),
                Text(exhibitions[i].date),
              ],
            ),
          ),
        ],
      ),
    );
  }
  return results;
}