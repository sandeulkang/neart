
import 'package:flutter/material.dart';
import 'package:neart/Lab/model_exhibitions.dart';

class Listviewtype extends StatefulWidget {
  final List<Exhibition> exhibitions;

  Listviewtype(
      {required this.exhibitions}); //required 안하면 The parameter can't have a value of 'null' because of its type, but the implicit default value is 'null'.에러 뜸
  _ListviewtypeState createState() => _ListviewtypeState();
}

class _ListviewtypeState extends State<Listviewtype> {
  late List<Exhibition> exhibitions;
  late List<Widget> images;
  late List<String> keywords;
  late List<String> titles;
  late List<bool> bookmarks;
  int _currentPage = 0;
  late String _currentKeyword;

  @override
  void initState() {
    super.initState();
    exhibitions = widget.exhibitions;
    images =
        exhibitions.map((m) => Image.asset('./assets/' + m.poster)).toList();
    keywords = exhibitions.map((m) => m.keyword).toList();
    bookmarks = exhibitions.map((m) => m.bookmark).toList();
    titles = exhibitions.map((m)=>m.title).toList();
    _currentKeyword = keywords[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3),
          ),
          SizedBox(
            height:400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  child: Text(titles[index]),
                );
              },
            ),
          ),

          Container(
              child: Row(
                children: [
                  Container(child: Column(children: [
                    bookmarks[_currentPage]
                        ? IconButton(icon: Icon(Icons.check), onPressed: (){},)
                        : IconButton(icon: Icon(Icons.add), onPressed: (){},),
                    Text('내가 즐겨찾기한 전시')
                  ],))
                ],
              )
          )
        ],
      ),
    );
  }
}
