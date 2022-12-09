import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class d extends StatefulWidget {
  const d({Key? key}) : super(key: key);

  @override
  State<d> createState() => _dState();
}

class _dState extends State<d> {
  @override
  Widget build(BuildContext context) {
    var exhibition;

    var widget;

    var heartExhibitDoc = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .collection('heart')
        .doc(widget.exhibition.title);

    return FutureBuilder(
        future: heartExhibitDoc.get(),
        builder: (context, snapshot) {
          return snapshot != null
              ? InkWell(
                  child: SvgPicture.asset(
                    "assets/onheart.svg",
                  ),
                  onTap: () {
                    setState(() {
                      heartExhibitDoc.delete();
                    });
                  },
                )
              : InkWell(
                  child: SvgPicture.asset(
                    "assets/offheart.svg",
                  ),
                  onTap: () {},
                );
        });
  }
}
