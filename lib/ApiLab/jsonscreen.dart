import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neart/ApiLab/api_adaptor.dart';
import 'package:xml2json/xml2json.dart';
import 'model_json.dart';

class JsonScreen extends StatefulWidget {

  @override
  State<JsonScreen> createState() => _JsonScreenState();
}


class _JsonScreenState extends State<JsonScreen> {
  List<dynamic> models = [];
  var responseBody;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

    fetchData() async{
    try {
      final url = await http.get(Uri.parse(
          'http://openapi.seoul.go.kr:8088/4267515774746b7339385148774d52/xml/ListExhibitionOfSeoulMOAInfo/1/5/'));


    if (url.statusCode == 200) {
        responseBody = utf8.decode(url.bodyBytes);
        var xml2json = Xml2Json()..parse(responseBody);
        var jsonString = xml2json.toParker(); //여기 점 두 개 해야 됨 이유는 모름
        final jsonResult = jsonDecode(jsonString) as Map<String, dynamic>;
        final jjsonresult = jsonResult["ListExhibitionOfSeoulMOAInfo"];
        // final jjjsonresult = jjsonresult["body"];
        // final jjjjsonresult = jjjsonresult["items"];
        List<dynamic> data = jjsonresult["row"];
        for (var i = 0; i <5; i++) {
          FirebaseFirestore
              .instance //앞에 var 붙이면 local변수가 돼서 아래에서 사용이 안 된다.
              .collection('exhibition')
              .doc(data[i]['DP_NAME'])
              .set({
              //date, keyword 작성 및 place 확인 요망
            'admission': '관람료: 무료' ,
            'explanation': data[i]['DP_INFO'],
            'place': '서울시립 미술관',
            'poster': data[i]['DP_MAIN_IMG'],
            'title': data[i]['DP_NAME'],
            'time':FieldValue.serverTimestamp(),
          });
        }


      return data;
    }
      else {
        throw Exception('Failed');
      }
    } catch(e){print(e);}
  }
}


