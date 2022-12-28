import 'package:flutter/material.dart';
import 'kakao_login.dart';
import 'main_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
                viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? 'https://postfiles.pstatic.net/MjAyMjExMjdfMTIw/MDAxNjY5NTUxMjg2OTQ4.LRuMV7Ike0UJuxyqAcxuFQ-W5DNkTcmziHjVnRAlbMEg.O-qz3HVtnQmNABwzqk-cWW93XSXTPbCt4U0FbZmLp5Ig.PNG.tksemf0628/%ED%94%84%EB%A1%9C%ED%95%84%EC%9D%B4%EB%AF%B8%EC%A7%80.png?type=w773',
            height: 50,),
            Text(
              '${viewModel.isLogined}',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.login();
                setState(() {});
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await viewModel.logout();
                setState(() {});
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

