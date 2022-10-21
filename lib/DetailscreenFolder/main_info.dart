import 'package:flutter/material.dart';

class MainInfo extends StatelessWidget {
  const MainInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: Container(
        height: 220,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.network(widget.exhibition.poster),
              width: MediaQuery.of(context).size.width * 0.35,
            ),
            Container(
              height: 220,
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exhibition.title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.exhibition.date,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.exhibition.place,
                  ),
                  SizedBox(height: 1),
                  Text(information.replaceAll("\\n", "\n"),
                      style: TextStyle(height: 1.5)),
                  SizedBox(height: 1),
                  Text(
                      widget.exhibition.admission
                          .replaceAll("\\n", "\n"),
                      style: TextStyle(height: 1.5)),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        heart
                            ? InkWell(
                          child: SvgPicture.asset(
                            "assets/onheart.svg",
                            width: 40,
                            height: 40,
                            color: Colors.red,
                          ),
                          onTap: () {
                            setState(() {
                              heart = !heart;
                              firebaseFirestore
                                  .collection('exhibition')
                                  .doc(widget
                                  .exhibition.title)
                                  .update({'heart': heart});
                            });
                          },
                        )
                            : InkWell(
                          child: SvgPicture.asset(
                            "assets/offheart.svg",
                            width: 40,
                            height: 40,
                            color: Colors.red,
                          ),
                          onTap: () {
                            setState(() {
                              heart = !heart;
                              firebaseFirestore
                                  .collection('exhibition')
                                  .doc(widget
                                  .exhibition.title)
                                  .update({'heart': heart});
                            });
                          },
                        ),
                        havebeen
                            ? InkWell(
                          child: SvgPicture.asset(
                            "assets/oncheck.svg",
                            width: 40,
                            height: 40,
                          ),
                          onTap: () {
                            setState(() {
                              havebeen = !havebeen;
                              firebaseFirestore
                                  .collection('exhibition')
                                  .doc(widget
                                  .exhibition.title)
                                  .update({
                                'havebeen': havebeen
                              });
                            });
                          },
                        )
                            : InkWell(
                          child: SvgPicture.asset(
                            "assets/off_check.svg",
                            width: 40,
                            height: 40,
                          ),
                          onTap: () {
                            setState(() {
                              havebeen = !havebeen;
                              firebaseFirestore
                                  .collection('exhibition')
                                  .doc(widget
                                  .exhibition.title)
                                  .update({
                                'havebeen': havebeen
                              });
                            });
                            print('daf');
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  }
}
