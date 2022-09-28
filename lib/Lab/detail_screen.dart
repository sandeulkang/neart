import 'package:flutter/material.dart';
import 'model_exhibitions.dart';

class DetailScreen extends StatefulWidget {
  final Exhibition exhibition;

  DetailScreen({required this.exhibition});

  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool bookmark = false;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    bookmark = widget.exhibition.bookmark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar( //헤더 영역
          pinned: false, //축소시 상단에 AppBar가 고정되는지 설정
          expandedHeight: 60, //헤더의 최대 높이
          flexibleSpace: FlexibleSpaceBar( //늘어나는 영역의 UI 정의
            title: Text(''),
          ),
        ),
         SliverFillRemaining(//내용 영역
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15,0,15,0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            child: Image.network(widget.exhibition.poster),
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                          InkWell(
                            child: bookmark
                                ? const Icon(Icons.check)
                                : const Icon(Icons.add),
                            onTap: () {},
                          )
                        ],
                      ),
                      Container(
                        padding:  EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.exhibition.title,
                              style:  TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                             SizedBox(height: 4),
                            Text(
                              widget.exhibition.date,
                              style:  TextStyle(fontSize: 13),
                            ),
                             SizedBox(height: 3),
                            Text(
                              widget.exhibition.place,
                              style:  TextStyle(fontSize: 13),
                            ),
                             SizedBox(height: 1),
                            Text(
                              widget.exhibition.placeinfo,
                              style:  TextStyle(fontSize: 11, height: 1.3),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Opacity(child: Divider(height: 20, thickness: 10,), opacity: 0.4,),
                Text('전시소개'),
                Text(widget.exhibition.explanation),
                Text('추천칼럼'),

              ],
            ),

        )
      ],
    ),

//        appBar: AppBar(),

        /***
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        child: Image.asset(widget.exhibition.poster),
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      InkWell(
                        child: bookmark
                            ? const Icon(Icons.check)
                            : const Icon(Icons.add),
                        onTap: () {},
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exhibition.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.exhibition.date,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.exhibition.place,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          widget.exhibition.placeinfo,
                          style: const TextStyle(fontSize: 11, height: 1.3),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Opacity(child: Divider(height: 20, thickness: 10,), opacity: 0.4,)
            ],
          ),
        ),
            ***/
      );
  }
}
