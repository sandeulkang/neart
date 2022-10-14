
import 'package:flutter/material.dart';
import 'package:neart/Lab/model_exhibitions.dart';
import 'package:neart/Lab/Listvew_builder.dart';
import 'package:neart/Lab/box_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../Lab/detail_screen.dart';

class Page2 extends StatefulWidget {
  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> streamData;

  @override
  void initState() {
    super.initState();
    streamData = firebaseFirestore.collection('exhibition').snapshots();
  }

  Widget _fetchData(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('exhibition').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occured: ${snapshot.error.toString()}'),
            );
          }
          if (snapshot.hasData) {
            return _buildBody(context, snapshot.data!.docs);
          }
          return LinearProgressIndicator();
        });
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    //실제적으로 movie들의 '리스트'가 생겨나는 타이밍
    List<Exhibition> exhibitions =
        snapshot.map((d) => Exhibition.fromSnapshot(d)).toList();
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(10,5,10,0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10, //수평 Padding
          crossAxisSpacing: 10,
          childAspectRatio: 0.5//수직 Padding
        ),
        semanticChildCount: 4,
        itemCount: exhibitions.length,
        itemBuilder: (BuildContext context, int i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(exhibition: exhibitions[i])),
                  );
                },
                child: Container(
                  height: 250,
                  child: Image.network(
                    exhibitions[i].poster,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exhibitions[i].title,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _fetchData(context);
  }
}
