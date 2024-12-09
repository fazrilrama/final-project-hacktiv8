import 'package:final_project/providers/news_provider.dart';
import 'package:final_project/screens/new_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Demo Assignment 3',
        theme: ThemeData(
          primaryColor: const Color(0XffEF6137),
          primarySwatch: Colors.amber
        ),
        home: const NewsPage(),
      ),
    );
  }
}


