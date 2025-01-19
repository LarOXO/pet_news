import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/news_list/bloc/news_bloc.dart';
import 'package:news/news.dart';
import 'package:news/repository/news_repository.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(repository: NewsRepository()),
        ),
      ],
      child: const News(),
    ),
  );
}
