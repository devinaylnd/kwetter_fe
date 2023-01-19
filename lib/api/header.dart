import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';
// import 'package:get/get.dart' as gt;
// import 'package:get_storage/get_storage.dart';

class HeaderInterceptor implements RequestInterceptor {
  static const String headerAppVersion = "x-app-version";
  static const String headerAuth = "Authorization";
  static const String headerBearer = "Bearer ";

  @override
  FutureOr<Request> onRequest(Request request) async {
    // String? token = GetStorage().read('token');
    // String header = await Utils.getHeader();
    String? token = "123123123123123";
    String header = "hakjdhkj3ekjqkjhejqe";

    Request newRequest = request.copyWith(headers: {
      headerAppVersion: "1.0.0",
      headerAuth: headerBearer + token,
      'x-device': header,
    });
    return newRequest;
  }
}

class ResponsesInterceptor implements ResponseInterceptor {
  @override
  FutureOr<Response> onResponse(Response response) async {
    if (response.body == null || response.body['status'] == null) {
    } else if (response.body['status'] == 2000) {
      // gt.Get.offAllNamed(Constants.pageUpdate);
    }
    return response;
  }
}

class HeaderAuthenticator extends Authenticator {
  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response,
      [Request? originalRequest]) async {
    if (response.body != null) {
      var data = jsonDecode(response.body);
      if (data['status'] != null) {
        if (response.statusCode == 401 || data['status'] == 401) {
          // String? newToken = await Utils.refreshToken();
          String? newToken = "17235163716537612537516273asd";

          final Map<String, String> updatedHeaders =
              Map<String, String>.of(request.headers);

          // if (newToken != null) {
          newToken = HeaderInterceptor.headerBearer + newToken;
          updatedHeaders.update(
              HeaderInterceptor.headerAuth, (String _) => newToken!,
              ifAbsent: () => newToken!);
          return request.copyWith(headers: updatedHeaders);
          // }
        }
      }
    }
    return null;
  }
}
