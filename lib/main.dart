import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import './models/bookmark.dart';
import './widgets/bookmark_list.dart';

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
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Bookmark>> futureUrls;

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
              child: FutureBuilder<List<Bookmark>>(
                future: futureUrls,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Bookmark> urls = snapshot.data!;
                    return BookmarkList(urls);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const CircularProgressIndicator();
                },
              ),
            )));
  }
}
