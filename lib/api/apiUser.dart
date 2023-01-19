import 'package:chopper/chopper.dart';
// ignore: depend_on_referenced_packages
import 'package:http/io_client.dart' as http;
import 'dart:io';

// import 'package:kwetter/api/header.dart';
import 'package:kwetter/utils/global.dart';

part 'apiUser.chopper.dart';

@ChopperApi()
abstract class ApiUserService extends ChopperService {
  static ApiUserService create() {
    final client = ChopperClient(
      baseUrl: Global.userApiUrl,
      client: http.IOClient(
        HttpClient()
          ..connectionTimeout = const Duration(seconds: 60)
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true,
      ),
      services: [
        _$ApiUserService(),
      ],
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      // authenticator: HeaderAuthenticator(),
      interceptors: [
        // HeaderInterceptor(),
        // ResponsesInterceptor(),
        HttpLoggingInterceptor(),
        (Request request) async {
          if (request.method == HttpMethod.Post) {
            chopperLogger.info(
                '=====================Performed a POST request=====================');
          } else {
            chopperLogger.info(
                '=====================Performed a GET request=====================');
          }
          return request;
        },
        (Response response) async {
          int statusCode = response.statusCode;
          if (statusCode > 400) {
            chopperLogger.severe('$statusCode NOT FOUND');
          }
          return response;
        },
      ],
    );
    return _$ApiUserService(client);
  }

  @Post(path: 'user/create')
  Future<Response> userCreate(@Body() Map<String, dynamic> body);

  @Get(path: 'user/{userId}')
  Future<Response> userGet(@Path() int userId);

  @Get(path: 'user/getUserByEmail')
  Future<Response> userGetByEmail(@Body() Map<String, dynamic> body);
}
