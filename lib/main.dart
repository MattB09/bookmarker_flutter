import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<UrlData>> fetchUrls() async {
  final response =
      await http.get(Uri.parse('https://apimocha.com/bookmarker/urls'));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body)['items'];
    return jsonResponse.map((data) => UrlData.fromJson(data)).toList();
  } else {
    throw Exception('Error fetching urls...');
  }
}

class Tag {
  final String id;
  final String name;

  Tag({required this.id, required this.name});
}

class UrlData {
  final String id;
  final bool isArchived;
  final bool isRead;
  final String? note;
  final List tags;
  final String title;
  final String url;

  UrlData(
      {required this.id,
      required this.isArchived,
      required this.isRead,
      this.note,
      required this.tags,
      required this.title,
      required this.url});

  factory UrlData.fromJson(Map<String, dynamic> json) {
    return UrlData(
      id: json['id'],
      isArchived: json['is_archived'],
      isRead: json['is_read'],
      note: json['note'],
      tags: json['tags'],
      title: json['title'],
      url: json['url'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<UrlData>> futureUrls;
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    futureUrls = fetchUrls();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bookmarker',
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Bookmarker'),
            ),
            body: Center(
              child: FutureBuilder<List<UrlData>>(
                future: futureUrls,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<UrlData> urls = snapshot.data!;
                    return ListView.builder(
                      itemCount: urls.length,
                      itemBuilder: (BuildContext context, int index) {
                        TextStyle _titleStyle;
                        if (urls[index].isRead == false) {
                          _titleStyle = _biggerFont.merge(
                              const TextStyle(fontWeight: FontWeight.bold));
                        } else {
                          _titleStyle = _biggerFont;
                        }
                        return Container(
                          height: 75,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).dividerColor)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                urls[index].url,
                                style: _titleStyle,
                              ),
                              if (urls[index].note != null)
                                Text(
                                  urls[index].note!,
                                  textAlign: TextAlign.left,
                                ),
                              //if (urls[index].tags.isNotEmpty)
                              //for (dynamic tag in urls[index].tags)
                              //Text(tag.name!.toString())
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            )));
  }
}
