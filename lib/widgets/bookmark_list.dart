import 'package:flutter/material.dart';

import '../models/bookmark.dart';
import './bookmark_list_item.dart';

class BookmarkList extends StatelessWidget {
  final List<Bookmark> urls;
  const BookmarkList(this.urls, {Key? key}) : super(key: key);
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: urls.length,
      itemBuilder: (BuildContext context, int index) {
        TextStyle titleStyle;
        if (urls[index].isRead == false) {
          titleStyle =
              _biggerFont.merge(const TextStyle(fontWeight: FontWeight.bold));
        } else {
          titleStyle = _biggerFont;
        }
        return BookmarkListItem(urls[index], titleStyle);
      },
    );
  }
}
