import './tag.dart';

class Bookmark {
  final String id;
  final bool isArchived;
  final bool isRead;
  final String? note;
  final List<Tag> tags;
  final String title;
  final String url;

  Bookmark(
      {required this.id,
      required this.isArchived,
      required this.isRead,
      this.note,
      required this.tags,
      required this.title,
      required this.url});

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    List<Tag> tagList = [];
    if (json['tags'] != null) {
      for (var tag in json['tags']) {
        tagList.add(Tag(id: tag['id'], name: tag['name']));
      }
    }
    return Bookmark(
      id: json['id'],
      isArchived: json['is_archived'],
      isRead: json['is_read'],
      note: json['note'],
      tags: tagList,
      title: json['title'],
      url: json['url'],
    );
  }
}
