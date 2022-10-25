
import 'package:flutter/material.dart';
import 'package:neart/Model/model_exhibitions.dart';

class Listviewtype extends StatefulWidget {
  final List<Exhibition> exhibitions;

  Listviewtype(
      {required this.exhibitions}); //required 안하면 The parameter can't have a value of 'null' because of its type, but the implicit default value is 'null'.에러 뜸
  _ListviewtypeState createState() => _ListviewtypeState();
}

class _ListviewtypeState extends State<Listviewtype> {
  late List<Exhibition> exhibitions;
  late List<Widget> posters;
  late List<String> keywords;
  late List<String> titles;
  late List<String> places;
  late List<String> dates;
  late List<bool> heart;
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    exhibitions = widget.exhibitions;
    posters =
        exhibitions.map((m) => Image.asset(m.poster)).toList();
    keywords = exhibitions.map((m) => m.keyword).toList();
    heart = exhibitions.map((m) => m.heart).toList();
    titles = exhibitions.map((m)=>m.title).toList();
    places = exhibitions.map((m) => m.place).toList();
    dates = exhibitions.map((m) => m.date).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height:430,
            child: ListView.builder(
              itemCount: exhibitions.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: SizedBox(
                        height: 350,
                        child: posters[index],
                      ),
                      onTap: () {},
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titles[index],
                            style:
                            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(places[index]),
                          const SizedBox(height: 2),
                          Text(dates[index]),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
