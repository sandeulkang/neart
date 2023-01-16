import 'package:flutter/material.dart';
import 'Checked_screen1.dart';
import 'Checked_screen2.dart';


//다녀온 전시, 남긴 리뷰 두 스크린으로 나뉠 것이다
class CheckedScreen extends StatefulWidget {
  @override
  State<CheckedScreen> createState() => _CheckedScreenState();
}

class _CheckedScreenState extends State<CheckedScreen> {
  bool isExhibitScreen = true; //내가 본 전시가 클릭되면 true 남긴 리뷰가 클릭되면 false 될 예정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '보고 온 전시',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isExhibitScreen = true;
                        });
                      },
                      child: Text('전시',style: TextStyle(color: isExhibitScreen ? Colors.black :Colors.black54),)),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isExhibitScreen = false;
                        });
                      },
                      child: Text('남긴 후기',style: TextStyle(color: isExhibitScreen ?Colors.black54 :Colors.black ),))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,0,15,0),
                child: isExhibitScreen ? const CheckedScreen1() : CheckedScreen2(),
              ),
            ],
          ),
        ));
  }
}
