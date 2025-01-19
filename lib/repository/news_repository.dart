import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/const.dart';

import 'model/news_model.dart';

class NewsRepository {
  Future<List<NewsModel>> getNews(
      {String? query, String category = 'general'}) async {
    try {
      final url = getNewsUrl(query: query, category: category);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles.map((article) => NewsModel.fromJson(article)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
