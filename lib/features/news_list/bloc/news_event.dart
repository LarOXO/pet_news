import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchNewsEvent extends NewsEvent {
  final String? query;

  const FetchNewsEvent({this.query});

  @override
  List<Object?> get props => [query];
}

class ChangeCategoryEvent extends NewsEvent {
  final String category;

  const ChangeCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}
