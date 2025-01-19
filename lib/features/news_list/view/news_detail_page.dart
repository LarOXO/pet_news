import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:news/repository/model/news_article.dart';
import 'package:news/repository/model/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel news;

  const NewsDetailPage({
    super.key,
    required this.news,
  });

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
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
      isFavorite = favorites.any((article) =>
          article.title == widget.news.title &&
          article.publishedAt
              .isAtSameMomentAs(DateTime.parse(widget.news.publishedAt)));
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
            article.publishedAt
                .isAtSameMomentAs(DateTime.parse(widget.news.publishedAt)));
      } else {
        final newsArticle = NewsArticle(
          title: widget.news.title,
          description: widget.news.description,
          imageUrl: widget.news.urlToImage,
          publishedAt: DateTime.parse(widget.news.publishedAt),
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
                  DateFormat('MM.dd.yyyy')
                      .format(DateTime.parse(widget.news.publishedAt)),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.news.urlToImage.isNotEmpty &&
                Uri.tryParse(widget.news.urlToImage)?.isAbsolute == true)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.news.urlToImage,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(height: 200),
                ),
              ),
            const SizedBox(height: 16),
            if (widget.news.author.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Author: ${widget.news.author}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              widget.news.description,
              style: const TextStyle(fontSize: 16),
            ),
            if (widget.news.content.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                widget.news.content,
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse(widget.news.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Read Full Article'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
