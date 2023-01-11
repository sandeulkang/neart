import 'package:flutter/material.dart';

import '../DetailscreenFolder/exhibition_detail_screen.dart';
import '../Model/model_exhibitions.dart';

class ExhibitionGridview extends StatelessWidget {

  ExhibitionGridview({this.list});

 var list;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5, //수평 Padding
          crossAxisSpacing: 1,
          childAspectRatio: 0.5),
      itemCount: list.data!.length,
      itemBuilder: (BuildContext context, int i) {
        List<Exhibition> exhibitions = list.data!
            .map((data) => Exhibition.fromSnapshot(data))
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ExhibitionDetailScreen(
                              exhibition: exhibitions[i])),
                  //즉 Exhibition 타입의 아이를 넘기는 거임
                );
              },
              child: SizedBox(
                height: 250,
                width: 180,
                child: Image.network(
                  exhibitions[i].poster,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 8, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exhibitions[i].title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(exhibitions[i].place),
                  const SizedBox(height: 2),
                  Text(exhibitions[i].date),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}