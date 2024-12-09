import 'dart:convert';

import 'package:final_project/models/news_model.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class NewsProvider with ChangeNotifier {
  List<NewsModel> _news = [];
  // ignore: non_constant_identifier_names
  final String ApiKey = '56718669708b45e99537f357562e7a4c';

  final url = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=56718669708b45e99537f357562e7a4c');

  List<NewsModel> get news {
    return [..._news];
  }

  Future<void> fetchNews([String? category]) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('si');

        final List<dynamic> articles = jsonData['articles'];  
        _news = articles.map((article) => NewsModel.fromJson(article)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load news');
      }
      
    } catch (err) {
      print('Error occurred: $err');
      rethrow;
    }
  }
  
  Future<void> fetchChange([String? category, String? type]) async {
    try {
      print('Category: $category');
      print('Type: $type');

      if(type == 'country') {
        var text = '';

        if(category == 'USA') {
          text = 'us';
        } else if(category == 'MEXICO') {
          text = 'mx';
        } else if(category == 'UNITED ARAB EMIRATES') {
          text = 'ua';
        } else if(category == 'NEW ZEALAND') {
          text = 'nz';
        } else if(category == 'ISRAEL') {
          text = 'il';
        } else if(category == 'INDONESIA') {
          text = 'id';
        }

        final urlCountry = Uri.parse('https://newsapi.org/v2/top-headlines?country=$text&apiKey=56718669708b45e99537f357562e7a4c');
        final response = await http.get(urlCountry);
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final List<dynamic> articles = jsonData['articles'];  
        _news = articles.map((article) => NewsModel.fromJson(article)).toList();
        
        notifyListeners();
      } else if(type == 'category') {
        final urlCategory = Uri.parse('https://newsapi.org/v2/top-headlines?category=$category&apiKey=56718669708b45e99537f357562e7a4c');
        final response = await http.get(urlCategory);
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final List<dynamic> articles = jsonData['articles'];  
        _news = articles.map((article) => NewsModel.fromJson(article)).toList();
        
        notifyListeners();
      } else if(type == 'channel') {
        final fixsCategory = category!.toLowerCase();
        final text = fixsCategory.replaceAll(' ', '-');
        final urlChannel = Uri.parse('https://newsapi.org/v2/top-headlines?sources=$text&apiKey=56718669708b45e99537f357562e7a4c');
        final response = await http.get(urlChannel);
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final List<dynamic> articles = jsonData['articles'];  
        _news = articles.map((article) => NewsModel.fromJson(article)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;  // Agar error dapat ditangani di catchError
    }
  }
}