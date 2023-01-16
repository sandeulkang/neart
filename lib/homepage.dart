import 'package:flutter/material.dart';
import 'package:neart/Page2/page2.dart';
import 'package:neart/Page4/page4.dart';
import 'package:neart/Page1/page1.dart';
import 'Page5/page5.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _index = 0;
  final _pages = [
    Page1(),
    const Page2(),
    const Page4(),
    const Page5(),
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('NeArt'),
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
        items: const [
           BottomNavigationBarItem(
            icon: Icon(Icons.home), label: 'home',),
           BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Exhibit'),
           BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: 'Curator'),
           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
        ],
      ),
    );
  }
}