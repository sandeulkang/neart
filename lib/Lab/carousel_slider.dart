import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:neart/Lab/model_exhibitions.dart';

class CarouselImage extends StatefulWidget {
  final List<Exhibition> exhibitions;

  CarouselImage(
      {required this.exhibitions}); //required 안하면 The parameter can't have a value of 'null' because of its type, but the implicit default value is 'null'.에러 뜸
  _CarouselImageState createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  late List<Exhibition> exhibitions;
  late List<Widget> images;
  late List<String> keywords;
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
    _currentKeyword = keywords[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3),
          ), // 왜 있는 거지?
          CarouselSlider(
            items: images,
            options: CarouselOptions(
              height: 330,
              onPageChanged: (index, reason) {
                setState(
                  () {
                    _currentPage = index;
                    _currentKeyword = keywords[_currentPage];
                  },
                );
              },
            ),
          ),
          Container(
            child: Text(_currentKeyword),
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
