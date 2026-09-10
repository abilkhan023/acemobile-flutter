import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../clubs/data/models.dart';

class NewsItem {
  const NewsItem({required this.id, this.title, this.name, this.content, this.description, this.thumbnailId, this.text});

  final String id;
  final String? title;
  final String? name;
  final String? content;
  final String? description;
  final String? thumbnailId;
  final String? text;

  factory NewsItem.fromJson(Map<String, dynamic> j) => NewsItem(
        id: (j['id'] ?? '').toString(),
        title: j['title']?.toString(),
        name: j['name']?.toString(),
        content: j['content']?.toString(),
        description: j['description']?.toString(),
        thumbnailId: j['thumbnail_id']?.toString(),
        text: j['text']?.toString(),
      );

  String get heading => name?.isNotEmpty == true ? name! : (title ?? '');
  String get subtitle => description ?? content ?? text ?? '';
}

class NewsApi {
  NewsApi(this._dio);

  final Dio _dio;

  Future<List<NewsItem>> list() => apiCall(() => _dio.get('/news'), (d) => unwrapList(d, NewsItem.fromJson));

  Future<NewsItem> get(String id) => apiCall(() => _dio.get('/news/$id'), (d) => NewsItem.fromJson(Map<String, dynamic>.from(d as Map)));
}

final newsApiProvider = Provider<NewsApi>((ref) => NewsApi(ref.watch(coreDioProvider)));
final newsListProvider = FutureProvider<List<NewsItem>>((ref) => ref.watch(newsApiProvider).list());
final newsItemProvider = FutureProvider.family<NewsItem, String>((ref, id) => ref.watch(newsApiProvider).get(id));
