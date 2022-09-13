import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '지금 인기 있는',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            Container( // 배경색 넣어줄 거 아니면 컨테이너 지워도 된다
              child: Table(
                border: TableBorder.all(borderRadius: BorderRadius.circular(10), color: Colors.black45),
                children: [
                  TableRow(children: [
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('서울')),
                      ),
                      onTap: (){},
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('강원')),
                      ),
                      onTap: (){},
                    ),
                  ],),
                  TableRow(children: [
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('광주,전라')),
                      ),
                      onTap: (){},
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('대구,경북')),
                      ),
                      onTap: (){},
                    ),
                  ],),
                  TableRow(children: [
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('대전,충청,세종')),
                      ),
                      onTap: (){},
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('부산,울산,경북')),
                      ),
                      onTap: (){},
                    ),
                  ],),
                  TableRow(children: [
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('인천,경기')),
                      ),
                      onTap: (){},
                    ),
                    InkWell(
                      child: SizedBox(
                        height: 45,
                        child: Center(child: Text('제주')),
                      ),
                      onTap: (){},
                    ),
                  ],),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
