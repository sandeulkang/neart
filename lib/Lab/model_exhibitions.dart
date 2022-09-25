class Exhibition {
  final String title;
  final String keyword;
  final String place;
  final String date;
  final bool bookmark;
  final String poster;
  final child;

  Exhibition.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        keyword = map['keyword'],
        place = map['place'],
        date = map['date'],
        bookmark = map['bookmark'],
        poster = map['poster'],
        child = map['child'];

  @override
  String toString() => "Exhibition<$title:$keyword>";
}
