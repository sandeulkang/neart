import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('지금 인기 있는',),
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0, 0 , 20, 0),
                scrollDirection: Axis.horizontal, //상위 싱글찰드 스크롤 뷰가 수직으로 씌워져 있는데 될지 의문
                child: Row(
                  children: [
                    InkWell(
                      child: Column(
                        children: [
                          Image.asset('assets/포스터1.jpg', width: 200,),
                          const Text('Teracota Frendship',)
                        ],
                      ),
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          Image.asset('assets/포스터2.png', width: 200,),
                          const Text('Conering',)
                        ],
                      ),
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          Image.asset('assets/포스터3.jpeg', width: 200,),
                          const Text('텍스트 뷔페',)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 40,),
              Text('지역별 전시'),
            ],
          ),
      ),
    );
  }
}
