import 'package:flutter/material.dart';

void needLoginDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });

        return Dialog(
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5)),
            child: const Center(
                child: Text(
                  '로그인이 필요한 서비스입니다.',
                  style: TextStyle(fontSize: 16),
                )),
          ),
        );
      });
}
