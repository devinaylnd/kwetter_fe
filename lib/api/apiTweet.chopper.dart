// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiTweet.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ApiTweetService extends ApiTweetService {
  _$ApiTweetService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiTweetService;

  @override
  Future<Response<dynamic>> tweetCreate(Map<String, dynamic> body) {
    final String $url = 'tweet/create';
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> tweetEdit(Map<String, dynamic> body) {
    final String $url = 'tweet/edit';
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> tweetGetByTweetId(int id) {
    final String $url = 'tweet/tweet-${id}';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> tweetGetByUserId(int id) {
    final String $url = 'tweet/user-${id}';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> tweetGetBySearch(Map<String, dynamic> body) {
    final String $url = 'tweet/getTweetBySearch';
    final $body = body;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> tweetDelete(int tweetId) {
    final String $url = 'tweet/${tweetId}';
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
