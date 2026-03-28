import 'package:dio/dio.dart';
import 'app_interceptor.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(AppInterceptor());
    return dio;
  }
}
