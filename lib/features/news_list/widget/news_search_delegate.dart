import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/news_list/bloc/news_bloc.dart';
import 'package:news/features/news_list/bloc/news_event.dart';
import 'package:news/features/news_list/bloc/news_state.dart';
import 'package:news/features/news_list/widget/card_news_list.dart';

class NewsSearchDelegate extends SearchDelegate {
  final NewsBloc newsBloc;

  NewsSearchDelegate(this.newsBloc);

  @override
  String get searchFieldLabel => 'Search news';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Когда пользователь возвращается из поиска, обновляем новости
        newsBloc.add(const FetchNewsEvent()); // Обновить список
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Запрос на получение новостей с поисковым запросом
    newsBloc.add(FetchNewsEvent(query: query));
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return Center(
            child: Text(
              'Please enable the internet.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          );
        } else if (state.news.isEmpty) {
          return Center(child: Text('No results found for "$query"'));
        } else {
          return ListView.builder(
            itemCount: state.news.length,
            itemBuilder: (context, index) {
              final news = state.news[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CardNewsList(news: news),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // Optional: Add real-time suggestions if needed.
  }
}
