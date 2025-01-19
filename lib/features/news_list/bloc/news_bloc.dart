import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/repository/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _repository;

  NewsBloc({required NewsRepository repository})
      : _repository = repository,
        super(const NewsState()) {
    on<FetchNewsEvent>(_onFetchNews);
    on<ChangeCategoryEvent>(_onChangeCategory);
  }

  Future<void> _onFetchNews(
      FetchNewsEvent event, Emitter<NewsState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final news = await _repository.getNews(
        query: event.query,
        category: state.selectedCategory,
      );

      emit(state.copyWith(
        news: news,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onChangeCategory(ChangeCategoryEvent event, Emitter<NewsState> emit) {
    emit(state.copyWith(
      selectedCategory: event.category,
      isLoading: true,
    ));
    add(const FetchNewsEvent());
  }
}
