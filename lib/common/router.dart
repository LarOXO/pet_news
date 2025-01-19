import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:news/features/favorite_list/view/favorite_list_page.dart';
import 'package:news/features/main/view/main_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const MainPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const FavoriteListPage(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const FavoriteListPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ),
  ],
);
