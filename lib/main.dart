import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import './models/bookmark.dart';

Future<List<Bookmark>> fetchUrls() async {
  final response =
      await http.get(Uri.parse('https://apimocha.com/bookmarker/urls'));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body)['items'];
    return jsonResponse.map((data) => Bookmark.fromJson(data)).toList();
  } else {
    throw Exception('Error fetching urls...');
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
  late Future<List<Bookmark>> futureUrls;
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    futureUrls = fetchUrls();
  }

  dynamic _launchURLBrowser(Uri url) async {
    var withHttps = Uri.https(url.authority, url.path);
    if (await canLaunchUrl(withHttps)) {
      await launchUrl(withHttps, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $withHttps';
    }
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
              child: FutureBuilder<List<Bookmark>>(
                future: futureUrls,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Bookmark> urls = snapshot.data!;
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
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          elevation: 5,
                          child: ListTile(
                              leading: IconButton(
                                icon: const Icon(Icons.link),
                                onPressed: () async => await _launchURLBrowser(
                                    Uri.parse(urls[index].url)),
                              ),
                              title: Text(
                                urls[index].url,
                                style: _titleStyle,
                              ),
                              subtitle: (urls[index].note != null)
                                  ? Text(
                                      urls[index].note!,
                                      textAlign: TextAlign.left,
                                    )
                                  : null,
                              trailing: (urls[index].tags.isNotEmpty)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: urls[index].tags.map((tag) {
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
