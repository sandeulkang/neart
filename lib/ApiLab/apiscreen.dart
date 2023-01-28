// import 'dart:html';
import 'dart:convert';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model_api.dart';

class ApiScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder<List>(
        future: running(context),
        builder: (BuildContext context,AsyncSnapshot<List> snapshot){
          if(!snapshot.hasData){return LinearProgressIndicator();}
          return Text(snapshot!.data![1]['title']);
        });
  }

  Future<List> running(context) async{
    final apixml = await http.get(Uri.parse('http://api.kcisa.kr/openapi/service/rest/meta4/getARKA1202?serviceKey=b94ef31f-9368-47b3-9477-62523456c940&numOfRows=3'));
    print('aa');
    final document = XmlDocument.parse(apixml.body);
    print('bb');
    final items = document.findAllElements('item');
    print('skrll');
    var list = <APIModel>[];

    items.forEach((node){
      list.add(APIModel.fromXml(node));
    });

    return list;

  }
}
