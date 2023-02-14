import 'package:flutter/material.dart';

class NoNetworkPage extends StatelessWidget {
  const NoNetworkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('네트워크 연결 후\n다시 실행해 주세요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15),))
    );
  }
}
