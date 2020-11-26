import 'dart:async';
import 'package:chopper/chopper.dart';


class Interceptor implements RequestInterceptor {

  static const String AUTH_HEADER = "Authorization";

  static const String BEARER = "Bearer ";

  static const String V4_AUTH_HEADER =
      "6b620a8ab956bb4d6bdf7f8edc5c070b";

  @override
  FutureOr<Request> onRequest(Request request) async {
    // 5
    Request newRequest = request.copyWith(headers: {AUTH_HEADER: BEARER + V4_AUTH_HEADER});
    return newRequest;
  }

}
