import 'package:dio/dio.dart';

import '../env.dart';

bool isHiddenClubItem(Object? item) {
  if (item is! Map) return false;
  if (Env.hiddenGameCenterIds.contains(item['game_center_id']?.toString())) return true;
  if (Env.hiddenBranchIds.contains(item['branch_id']?.toString())) return true;
  final id = item['id']?.toString();
  if (id != null && (Env.hiddenGameCenterIds.contains(id) || Env.hiddenBranchIds.contains(id))) return true;
  if (Env.hiddenSlugs.contains(item['slug']?.toString())) return true;
  final center = item['game_center'];
  if (center is Map) {
    if (Env.hiddenGameCenterIds.contains(center['id']?.toString())) return true;
    if (Env.hiddenSlugs.contains(center['slug']?.toString())) return true;
  }
  return false;
}

Object? stripHiddenClubs(Object? data) {
  if (data is List) return [for (final e in data) if (!isHiddenClubItem(e)) e];
  if (data is Map && data['data'] is List) {
    final list = stripHiddenClubs(data['data']) as List;
    return {...data, 'data': list, if (data['items'] is num) 'items': list.length};
  }
  return data;
}

bool isHiddenClubPath(String path) {
  final segments = path.split('/').where((s) => s.isNotEmpty);
  return segments.any((s) => Env.hiddenGameCenterIds.contains(s) || Env.hiddenBranchIds.contains(s));
}

class HiddenClubsInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    if (data is Map && data['data'] is! List && isHiddenClubItem(data)) {
      return handler.reject(
        DioException(requestOptions: response.requestOptions, response: Response(requestOptions: response.requestOptions, statusCode: 404, data: {'detail': 'hidden'}), type: DioExceptionType.badResponse),
      );
    }
    response.data = stripHiddenClubs(data);
    handler.next(response);
  }
}
