import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neart/Page/Ppagee1.dart';

import 'package:neart/Page/page2.dart';
import 'package:neart/Page/page3.dart';
import 'package:neart/Page/page4.dart';
import 'package:neart/Page/page5_on.dart';
import 'package:neart/Page/ppage1.dart';
import 'package:neart/authenticationpage.dart';
import 'package:neart/search_screen.dart';

import 'Page/page5.dart';
import 'Page/page5_null.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _index = 0;
  final _pages = [
    Ppage1(),
    Page2(),
    const Page4(),
    const Page5(),
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: () {

                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ),
              const Text('NeArt'),
              IconButton(
                onPressed: () {Navigator.pushNamed(context, "/SearchScreen");},
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
        ),
      ),
      body:_pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed, //라벨이 항상 보이게 하는 것
        onTap: (index){
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search) ,
              label: 'Exhibit'),

          const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: 'Curator'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
        ],
      ),
    );
  }
}