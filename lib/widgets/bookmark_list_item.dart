import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/bookmark.dart';

class BookmarkListItem extends StatelessWidget {
  final Bookmark bookmark;
  final TextStyle titleStyle;
  const BookmarkListItem(this.bookmark, this.titleStyle, {Key? key})
      : super(key: key);

  dynamic launchURLBrowser(Uri url) async {
    var withHttps = Uri.https(url.authority, url.path);
    if (await canLaunchUrl(withHttps)) {
      await launchUrl(withHttps, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $withHttps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 5,
      child: ListTile(
          leading: IconButton(
            icon: const Icon(Icons.link),
            onPressed: () async =>
                await launchURLBrowser(Uri.parse(bookmark.url)),
          ),
          title: Text(
            bookmark.url,
            style: titleStyle,
          ),
          subtitle: (bookmark.note != null)
              ? Text(
                  bookmark.note!,
                  textAlign: TextAlign.left,
                )
              : null,
          trailing: (bookmark.tags.isNotEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bookmark.tags.map((tag) {
                    return Chip(
                      label: Text(tag.name),
                    );
                  }).toList(),
                )
              : null
          //for (dynamic tag in urls[index].tags)
          //Text(tag.name!.toString())
          ),
    );
  }
}
