// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiUser.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ApiUserService extends ApiUserService {
  _$ApiUserService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiUserService;

  @override
  Future<Response<dynamic>> userCreate(Map<String, dynamic> body) {
    final String $url = 'user/create';
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
  Future<Response<dynamic>> userGet(int userId) {
    final String $url = 'user/${userId}';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> userGetByEmail(Map<String, dynamic> body) {
    final String $url = 'user/getUserByEmail';
    final $body = body;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
