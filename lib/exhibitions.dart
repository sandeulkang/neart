import 'package:flutter/material.dart';


class Exhibitions extends StatelessWidget {
  Exhibitions({
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
            height: 240,
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