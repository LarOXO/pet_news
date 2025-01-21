# News App

## Описание
News App — это приложение для просмотра последних новостей, использующее API NewsAPI для получения данных. Оно поддерживает фильтрацию по категориям и поисковую функциональность для поиска новостей по ключевым словам.

## Используемые технологии
- **Dart**
- **Flutter**
- **NewsAPI** (https://newsapi.org)
- **SharedPreferences** (для сохранения избранных новостей)

## API
Для получения новостей используется NewsAPI. В проекте используется следующий базовый URL для запросов:

```dart
const apiKey = 'YOU_API';  // Ваш ключ API
const baseUrl = 'https://newsapi.org/v2';
const endpoint = '$baseUrl/top-headlines';

Функция для генерации URL для получения новостей:

String getNewsUrl({String? query, String category = 'general'}) {
  final queryParam = query != null && query.isNotEmpty ? '&q=$query' : '';
  return '$endpoint?country=us&category=$category$queryParam&apiKey=$apiKey';
}

Доступные категории:

const categories = [
  'general',
  'business',
  'entertainment',
  'health',
  'science',
  'sports',
  'technology',
];
