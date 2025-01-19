import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:news/repository/model/news_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteDetailPage extends StatefulWidget {
  final NewsArticle news;

  const FavoriteDetailPage({
    super.key,
    required this.news,
  });

  @override
  State<FavoriteDetailPage> createState() => _FavoriteDetailPageState();
}

class _FavoriteDetailPageState extends State<FavoriteDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    final favorites = favoritesJson
        .map((json) => NewsArticle.fromJson(jsonDecode(json)))
        .toList();
    setState(() {
      isFavorite = favorites.any((news) =>
          news.title == widget.news.title &&
          news.publishedAt.isAtSameMomentAs(widget.news.publishedAt));
    });
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    final favorites = favoritesJson
        .map((json) => NewsArticle.fromJson(jsonDecode(json)))
        .toList();

    setState(() {
      if (isFavorite) {
        favorites.removeWhere((article) =>
            article.title == widget.news.title &&
            article.publishedAt.isAtSameMomentAs(widget.news.publishedAt));
      } else {
        final newsArticle = NewsArticle(
          title: widget.news.title,
          description: widget.news.description,
          imageUrl: widget.news.imageUrl,
          publishedAt: widget.news.publishedAt,
          source: widget.news.source,
        );
        favorites.add(newsArticle);
      }
      isFavorite = !isFavorite;
    });

    await prefs.setStringList(
      'favorites',
      favorites.map((article) => jsonEncode(article)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('News Detail'),
        actions: [
          IconButton(
            onPressed: () => _toggleFavorite(),
            icon: !isFavorite
                ? SvgPicture.asset('assets/icons/favorite_disable.svg',
                    width: 24, height: 24)
                : SvgPicture.asset('assets/icons/favorite_select.svg',
                    width: 24, height: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.news.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  widget.news.source,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MM.dd.yyyy').format(widget.news.publishedAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.news.imageUrl.isNotEmpty &&
                Uri.tryParse(widget.news.imageUrl)?.isAbsolute == true)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.news.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(height: 200),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              widget.news.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
