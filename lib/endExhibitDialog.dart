import 'package:flutter/material.dart';

void endExhibitDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });

        return Dialog(
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15)),
            child: const Center(
                child: Text(
                  '종료된 전시로,\n상세 페이지를 확인할 수 없어요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                )),
          ),
        );
      });
}
