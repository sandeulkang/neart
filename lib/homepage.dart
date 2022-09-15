import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neart/Page/page1.dart';
import 'package:neart/Page/page2.dart';
import 'package:neart/Page/page3.dart';
import 'package:neart/Page/page4.dart';
import 'package:neart/Page/page5.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _index = 0;
  final _pages = [
    const Page1(), //index = 0일때
    const Page2(), //index = 1일때
    const Page3(),
    const Page4(),
    const Page5(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
              ),
              const Text('NeArt'),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
        ),
      ),
      body:_pages[_index], //이해 안 되는 거: 현 _index=0인데 어떻게 index=1일때 페이지가 뜨는 건지, pages는 리스트 이름임 그러니 실제 위젯(Page)와 달라도 상관이 없는거. 왜냐ㅐ? 실행되는건 pages라는 리스트 안의 Page1,2,...니까
      //그 이유: _pages[0] = Page1임... 그렇다면 _pages[1] = Page2인데
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
              icon: SvgPicture.asset(
                "assets/glass.svg",
                color: Colors.black38,
                width: 22,
                height: 22,
              ),
              label: 'Exhibit'),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/other.svg",
              color: Colors.black38,
              width: 22,
              height: 22,
            ),
            label: 'Other',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: 'Curator'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
        ],
      ),
    );
  }
}

