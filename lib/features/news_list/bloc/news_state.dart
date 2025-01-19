import 'package:equatable/equatable.dart';
import 'package:news/repository/model/news_model.dart';

class NewsState extends Equatable {
  final List<NewsModel> news;
  final String selectedCategory;
  final bool isLoading;
  final String? error;

  const NewsState({
    this.news = const [],
    this.selectedCategory = 'general',
    this.isLoading = false,
    this.error,
  });

  NewsState copyWith({
    List<NewsModel>? news,
    String? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return NewsState(
      news: news ?? this.news,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [news, selectedCategory, isLoading, error];
}
