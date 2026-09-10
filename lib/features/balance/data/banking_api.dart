import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';

class BankingApi {
  BankingApi(this._dio);

  final Dio _dio;

  Future<String?> kaspiPay({required num sum, required String username, required String clubSlug}) => apiCall(
        () => _dio.post('/api/kaspi_transactions/pay', data: {
          'account': '$username\$$clubSlug',
          'sum': sum * 100,
          'is_mobile': true,
        }),
        (d) => d is Map ? d['redirectUrl']?.toString() : null,
      );
}

final bankingApiProvider = Provider<BankingApi>((ref) => BankingApi(ref.watch(bankingDioProvider)));
