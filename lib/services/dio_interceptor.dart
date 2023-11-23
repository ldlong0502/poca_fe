import 'package:dio/dio.dart';
import 'package:poca/providers/preference_provider.dart';

class DioInterceptor extends Interceptor {
  DioInterceptor(this.dio);
  final Dio dio;
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await PreferenceProvider.getString('access_token');
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type']= 'application/json';
    super.onRequest(options, handler);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403 ||
        err.response?.statusCode == 401) {
      await refreshToken();
      handler.resolve(await _retry(err.requestOptions));
    }

    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    final refreshToken = await PreferenceProvider.getString('refresh_token');
    final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});

    if (response.statusCode == 201) {
      await PreferenceProvider.setString('access_token' , response.data['accessToken']);
      return true;
    } else {
      await PreferenceProvider.removeJsonToPref('access_token');
      return false;
    }
  }}