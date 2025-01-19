import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/news_list/bloc/news_bloc.dart';
import 'package:news/features/news_list/bloc/news_event.dart';
import 'package:news/features/news_list/bloc/news_state.dart';
import 'package:news/features/news_list/widget/card_news_list.dart';
import 'package:news/features/news_list/widget/news_category_list.dart';
import 'package:news/features/news_list/widget/news_search_delegate.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  void _fetchNews() {
    context.read<NewsBloc>().add(const FetchNewsEvent());
  }

  void _onCategorySelected(String category) {
    context.read<NewsBloc>().add(ChangeCategoryEvent(category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('News'),
        leading: IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: NewsSearchDelegate(context.read<NewsBloc>()),
            );
          },
          icon: const Icon(Icons.search),
        ),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return Column(
            children: [
              NewsCategoryList(
                selectedCategory: state.selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
              if (state.isLoading)
                Expanded(child: _buildLoading())
              else if (state.error != null)
                Expanded(child: _buildError())
              else
                Expanded(child: _buildNewsList(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Please enable the internet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(NewsState state) {
    return RefreshIndicator(
      onRefresh: () async {
        _fetchNews();
      },
      child: ListView.builder(
        itemCount: state.news.length,
        itemBuilder: (context, index) {
          final news = state.news[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CardNewsList(news: news),
          );
        },
      ),
    );
  }
}
