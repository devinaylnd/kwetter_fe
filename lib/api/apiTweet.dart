import 'package:chopper/chopper.dart';
// ignore: depend_on_referenced_packages
import 'package:http/io_client.dart' as http;
import 'dart:io';

// import 'package:kwetter/api/header.dart';
import 'package:kwetter/utils/global.dart';

part 'apiTweet.chopper.dart';

@ChopperApi()
abstract class ApiTweetService extends ChopperService {
  static ApiTweetService create() {
    final client = ChopperClient(
      baseUrl: Global.tweetApiUrl,
      client: http.IOClient(
        HttpClient()
          ..connectionTimeout = const Duration(seconds: 60)
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true,
      ),
      services: [
        _$ApiTweetService(),
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
    return _$ApiTweetService(client);
  }

  @Post(path: 'tweet/create')
  Future<Response> tweetCreate(@Body() Map<String, dynamic> body);

  @Put(path: 'tweet/edit')
  Future<Response> tweetEdit(@Body() Map<String, dynamic> body);

  @Get(path: 'tweet/tweet-{id}')
  Future<Response> tweetGetByTweetId(@Path() int id);

  @Get(path: 'tweet/user-{id}')
  Future<Response> tweetGetByUserId(@Path() int id);

  @Get(path: 'tweet/getTweetBySearch')
  Future<Response> tweetGetBySearch(@Body() Map<String, dynamic> body);

  @Delete(path: 'tweet/{tweetId}')
  Future<Response> tweetDelete(@Path() int tweetId);
}
