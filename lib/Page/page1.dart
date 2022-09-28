import 'package:flutter/material.dart';
import 'package:neart/Lab/model_exhibitions.dart';
import 'package:neart/Lab/Listvew_builder.dart';

class  Page1 extends StatefulWidget {
  _Page1 createState() => _Page1();
}

class _Page1 extends State<Page1> {
  List<Exhibition> exhibitions = [
    Exhibition.fromMap(
        {
          'title' : 'Teracota Friendship',
          'place': '국립현대미술관',
          'date' : '07.27.-09.25.',
          'bookmark' : false,
          'keyword' : '서울/입체/도자기',
          'poster' : 'assets/포스터1.jpg',
          'child' : Image.asset('assets/포스터1.jpg'),
        }
    ),
    Exhibition.fromMap(
        {
          'title' : 'Teracota Friep',
          'place': '국립현대미술관',
          'date' : '07.27.-09.25.',
          'bookmark' : false,
          'keyword' : '서울/입체/도자기',
          'poster' : 'assets/포스터1.jpg',
          'child' : Image.asset('assets/포스터1.jpg'),
        }
    ),
    Exhibition.fromMap(
        {
          'title' : 'Teraendship',
          'place': '국립현대미술관',
          'date' : '07.27.-09.25.',
          'bookmark' : false,
          'keyword' : '서울/입체/도자기',
          'poster' : 'assets/포스터1.jpg',
          'child' : Image.asset('assets/포스터1.jpg'),
        }
    ),
    Exhibition.fromMap(
        {
          'title' : 'Teracota Friendship',
          'place': '국립현대미술관',
          'date' : '07.27.-09.25.',
          'bookmark' : false,
          'keyword' : '서울/입체/도자기',
          'poster' : 'assets/포스터1.jpg',
          'child' : Image.asset('assets/포스터1.jpg'),
        }
    ),
    Exhibition.fromMap(
        {
          'title' : 'Teracota Friendship',
          'place': '국립현대미술관',
          'date' : '07.27.-09.25.',
          'bookmark' : false,
          'keyword' : '서울/입체/도자기',
          'poster' : '포스터1.jpg',
          'child' : Image.asset('assets/포스터1.jpg'),
        }
    )

  ];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '지금 인기 있는',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Listviewtype(exhibitions: exhibitions),
          SizedBox(height: 60,),
          const Text(
            '지역별 전시',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
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
            height: 60,
          ),
          const Text(
            '분야별 전시', //종류? 장르?
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleButton(
                onTap: () {},
                text: '평면',
                child: Image.asset("assets/에곤실레.jpg"),
              ),
              CircleButton(
                onTap: () {},
                text: '영상',
                child: Image.asset("assets/영상.png"),
              ),
              CircleButton(
                onTap: () {},
                text: '입체',
                child: Image.asset("assets/조각.jpg"),
              ),
              CircleButton(
                onTap: () {},
                text: '체험',
                child: Image.asset("assets/체험.jpg"),
              ),
              CircleButton(
                onTap: () {},
                text: '대학',
                child: Image.asset("assets/대하.jpg"),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          const Text(
            '최근에 시작한',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainExhibit(
                  title: '길 배틀 : 프리즌 프리덤',
                  place: '워킹하우스뉴욕 한남',
                  date: '07.27.-09.25.',
                  onTap: () {},
                  child: Image.asset('assets/포스터5.jpg'),
                ),
                Container(width: 10),
                MainExhibit(
                  title: '김기주 : assortiment(조합)',
                  place: '갤러리엠나인',
                  date: '09.16.-10.30.',
                  onTap: () {},
                  child: Image.asset('assets/포스터6.jfif'),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          const Text(
            '아트 칼럼',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              MainColumn(
                title:'10월, 우리가 주목해야 할 전시 컬렉션',
                explanation: '최진희는 그림 금손으로 소개됐다. 최진희는 동양화와 서양화가 섞인 그림을 배우고 갤러리까지 오픈해 작품 활동을 하고 있다는 것이다. 정다경은 “최진희 선배님께서 10월에 전시회를 연다 하더라”라며 “최진희 선배님이 굉장히 오랫동안 그림을',
                child: Image.asset('assets/exam.jpg'),
                onTap: () {},
              ),
              MainColumn(
                title: '아트퍼니쳐 속에서 나타나는 예술과 디자인의 비경계',
                explanation: '아트와 디자인의 경계가 허물어지는 현상을 아트퍼니쳐에서 탐구하다!',
                child: Image.asset('assets/가구칼럼.jpg'),
                onTap: () {},
              ),
              MainColumn(
                title: '강산들이 선정한 에곤쉴레의 3대 작품',
                explanation: '사실 잘 모른다. 에곤실레도 저 그림을 보고 좋아하게 된 건 맞는데 에곤실레를 주인공으로 한 영화 배우가 잘생겨서 실존인물 에곤실레마저 나한테 매력적인 인물이 돼 버렸다',
                child: Image.asset('assets/칼럼3.jpg'),
                onTap: () {},
              ),
              MainColumn(
                title: '이 꽃은 이름이 뭔가요?',
                explanation: '인하대학교의 산책로에서 찍힌 이 꽃, 정체가 무엇일까? 내가 찍었는데 모른다!',
                child: Image.asset('assets/칼럼4.jpg'),
                onTap: () {},
              )
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

  dynamic
  onTap; //final로 하면 Prefer typing uninitialized variables and fields.이라는 경고가 떠서 dynamic으로 함
  dynamic
  child; //근데 dynamic으로 하면 This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final: 어쩌고 경고 뜸
  dynamic width;
  dynamic height;
  dynamic text;

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
        const SizedBox(
          height: 7,
        ),
        Text('$text'),
      ],
    );
  }
}

class MainExhibit extends StatelessWidget {
  MainExhibit({
    Key? key,
    this.child,
    this.title,
    this.place,
    this.date,
    this.onTap,
  }) : super(key: key);

  final title;
  final place;
  final date;
  final child;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: SizedBox(
            height: 350,
            child: child,
          ),
          onTap: () {},
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 12, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 4,
              ),
              Text('$place'),
              const SizedBox(height: 2),
              Text('$date'),
            ],
          ),
        ),
      ],
    );
  }
}

class MainColumn extends StatelessWidget {
  MainColumn({Key? key, this.child, this.title, this.explanation, this.onTap})
      : super(key: key);

  final child;
  final title;
  final explanation;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 5, 0, 0),
      child: GestureDetector(
        child: Row(
          children: [
            SizedBox(child: child, height: 80, width:100),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                width: MediaQuery.of(context).size.width - 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '$explanation',
                      style: TextStyle(fontSize: 10,color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
                height: 80),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
