import 'package:flutter/material.dart';
import 'package:neart/Lab/model_exhibitions.dart';
import 'package:neart/Lab/Listvew_builder.dart';
import 'package:neart/Lab/detail_screen.dart';

class BoxSlider extends StatefulWidget {
  late final List<Exhibition> exhibitions;
  BoxSlider({required this.exhibitions});

  @override
  State<BoxSlider> createState() => _BoxSliderState();
}

class _BoxSliderState extends State<BoxSlider> {

  late List<Exhibition> exhibitions;
  late List<Widget> posters;
  late List<String> keywords;
  late List<String> titles;
  late List<String> places;
  late List<String> dates;
  late List<bool> bookmarks;
  late List<String> placeinfoes;
  late List<String> explanations;

  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    exhibitions = widget.exhibitions;
    posters = exhibitions.map((m) => Image.asset(m.poster)).toList();
    keywords = exhibitions.map((m) => m.keyword).toList();
    bookmarks = exhibitions.map((m) => m.bookmark).toList();
    titles = exhibitions.map((m)=>m.title).toList();
    places = exhibitions.map((m) => m.place).toList();
    dates = exhibitions.map((m) => m.date).toList();
    placeinfoes = exhibitions.map((m)=>m.placeinfo).toList();
    explanations = exhibitions.map((m)=>m.explanation).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
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
            onTap: () {Navigator.push(
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
            child: SizedBox(
              height: 350,
              child: Image.network(exhibitions[i].poster),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
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
