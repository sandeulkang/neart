import 'package:flutter/material.dart';

import '../Model/model_article.dart';

class ArticleScreen extends StatefulWidget {
  final Article article;

  ArticleScreen({required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {

  dynamic article;

  void initState() {
    super.initState();
    article = widget.article;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
