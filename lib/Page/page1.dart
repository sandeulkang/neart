import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '지금 인기 있는',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 350,
                        child: Image.asset(
                          'assets/포스터1.jpg',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 7, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Teracota Frendship',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text('국립 현대 미술관'),
                            const Text('09.02.-10.06.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 10),
                InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 350,
                        child: Image.asset(
                          'assets/포스터2.png',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 7, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Conering',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text('아마도 예술공간'),
                            const Text('09.27.-09.25.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 20),
                InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 350,
                        child: Image.asset(
                          'assets/포스터3.png',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 7, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '텍스트 뷔페',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text('수건과 화환'),
                            const Text('09.02.-10.06.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            '지역별 전시',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Container(
            // 배경색 넣어줄 거 아니면 컨테이너 지워도 된다
            child: Table(
              border: TableBorder.all(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black45),
              children: [
                TableRow(
                  children: [
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('서울')),
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('강원')),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('광주,전라')),
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('대구,경북')),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('대전,충청,세종')),
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('부산,울산,경북')),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('인천,경기')),
                      ),
                      onTap: () {},
                    ),
                    InkWell(
                      child: const SizedBox(
                        height: 45,
                        child: Center(child: Text('제주')),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            '분야별 전시', //종류? 장르?
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleButton(
                child: Image.asset("assets/에곤실레.jpg"),
                onTap: () {},
                text: '평면',
              ),
              CircleButton(
                child: Image.asset("assets/영상.png"),
                onTap: () {},
                text: '영상',
              ),
              CircleButton(
                child: Image.asset("assets/chair.jpg"),
                onTap: () {},
                text: '입체',
              ),
              CircleButton(
                child: Image.asset("assets/chair.jpg"),
                onTap: () {},
                text: '체험',
              ),
              CircleButton(
                child: Image.asset("assets/chair.jpg"),
                onTap: () {},
                text: '대학',
              ),
            ],
          )
        ],
      ),
    );
  }
}

//서클 버튼 만들기
class CircleButton extends StatelessWidget {
  CircleButton({
    //생성자를 한번 적어주고 가야한다. 여기서 기본값 지정 가능. 아래에 변수를 먼저 만들어주고 생성자를 적어주어야 당연히 에러가 안나겠지!
    Key? key,
    this.onTap,
    this.child,
    this.width,
    this.height,
    this.text,
  }) : super(key: key);

  final onTap;
  final child;
  final width;
  final height;
  final text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: child,
            ),
          ),
          onTap: () {
            if (onTap != null) onTap();
          },
        ),
        SizedBox(height: 7,),
        Text('$text'),
      ],
    );
  }
}
