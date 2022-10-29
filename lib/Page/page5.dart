
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:neart/Page/page5_null.dart';
import 'package:neart/Page/page5_on.dart';
import 'package:neart/authenticationpage.dart';

import '../Lab/ppage5_on.dart';

class Page5 extends StatefulWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  final providerConfigs = [EmailProviderConfiguration()];

  void function = (){ FirebaseFirestore.instance
      .collection('member')
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .set({'email': FirebaseAuth.instance.currentUser!.email!});};

  @override
  Widget build(BuildContext context) {
    return
      FirebaseAuth.instance.currentUser == null
        ? Page5_null()
        : Ppage5_on();



/***
    return FirebaseAuth.instance.currentUser == null ? '/Page5_null' : '/Page5_on',
    routes: {
    '/Page5_null': (context) {
    return SignInScreen(
    providerConfigs: providerConfigs,
    actions: [
    AuthStateChangeAction<SignedIn>((context, state) {
    Navigator.pushReplacementNamed(context, '/Page5_on');
    }),
    ],
    );
    },
    '/Page5_on': (context) {
    return ProfileScreen(
    providerConfigs: providerConfigs,
    actions: [
    SignedOutAction((context) {
    Navigator.pushReplacementNamed(context, '/Page5_null');
    }),
    ],
    );
    },
    },
    ***/
  }
}
