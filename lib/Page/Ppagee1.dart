import 'package:flutter/material.dart';
import 'package:neart/Lab/model_exhibitions.dart';
import 'package:neart/Lab/Listvew_builder.dart';
import 'package:neart/Lab/box_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Ppagee1 extends StatefulWidget {
  const Ppagee1({Key? key}) : super(key: key);

  @override
  State<Ppagee1> createState() => _Ppagee1State();
}

class _Ppagee1State extends State<Ppagee1> {

  CollectionReference product = FirebaseFirestore.instance.collection(
      'exhibition');


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: product.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return
              ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text(documentSnapshot['title']),
                        subtitle: Text(documentSnapshot['date']),
                      ),
                    );
                  });
          }
          return CircularProgressIndicator();
        }
    );
  }
}
