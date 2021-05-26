import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';
import 'package:flutter_repository/network_repositories/network_config.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:flutter_repository/src/constants/constants.dart';
import 'package:uri/uri.dart';

abstract class RestRepositoryImp<ItemType> implements RestRepository<ItemType> {
  final RestRepositoryClient _client;
  final NetworkConfig networkConfig;
  final UriBuilder _uriBuilder = UriBuilder();

  RestRepositoryImp(
      {@required NetworkConfig networkConfig,
      @required RestRepositoryClient client})
      : networkConfig = networkConfig,
        _client = client {
    _uriBuilder.scheme = networkConfig.apiScheme;
    _uriBuilder.host = networkConfig.apiHost;
    _uriBuilder.port = networkConfig.apiPort;
  }

  String get getAllRoute => null;
  String get getOneRoute => null;
  String get createRoute => null;
  String get updateRoute => null;
  String get deleteRoute => null;

  String get defaultRoute => null;

  @override
  ItemCreator get defaultParseFunction => null;

  @override
  ItemCreator get getAllParseFunction => null;

  @override
  ItemCreator get getOneParseFunction => null;

  @override
  ItemCreator get createParseFunction => null;

  @override
  ItemCreator get updateParseFunction => null;

  @override
  ItemCreator get deleteParseFunction => null;

  @override
  Future<RestRepositoryResult<Page<ItemType>>> getPage(int page, int pageSize,
      [Map<String, String> queryParams = const <String, String>{}]) {
    return null;
  }

  @override
  Future<RestRepositoryResult<List<ItemType>>> getAll(
      [Map<String, String> queryParams = const <String, String>{}]) async {
    _uriBuilder.path = defaultRoute ?? getAllRoute;
    _uriBuilder.queryParameters = queryParams;

    final url = _uriBuilder.build().toString();
    final request = RestRepositoryRequest(url: url, httpMethod: 'GET');
    final response = await performRequest(request);
    final res = await parseResponse<List<ItemType>>(
        response: response,
        parseFunction: defaultParseFunction ?? getAllParseFunction);
    return res;
  }

  @override
  Future<RestRepositoryResult<ItemType>> getOne(int id) async {
    _uriBuilder.path = '${defaultRoute ?? getOneRoute}/${id.toString()}';
    final url = _uriBuilder.build().toString();
    final request = RestRepositoryRequest(
        url: url, httpMethod: 'GET', headers: defaultHeaders);
    final response = await performRequest(request);
    return parseResponse<ItemType>(
        response: response,
        parseFunction: defaultParseFunction ?? getOneParseFunction);
  }

  @override
  Future<RestRepositoryResult<ItemType>> create(
      Map<String, dynamic> body) async {
    _uriBuilder.path = defaultRoute ?? createRoute;
    final url = _uriBuilder.build().toString();
    final request = RestRepositoryRequest(
        url: url, httpMethod: 'POST', body: body, headers: defaultHeaders);
    final response = await performRequest(request);
    final res = await parseResponse<ItemType>(
        response: response,
        parseFunction: defaultParseFunction ?? createParseFunction);

    return res;
  }

  Future<RestRepositoryResult<ItemType>> update(
      dynamic id, Map<String, dynamic> body) async {
    _uriBuilder.path = (defaultRoute ?? updateRoute) + '/$id';
    final url = _uriBuilder.build().toString();
    final request = RestRepositoryRequest(
        url: url, httpMethod: 'PUT', headers: defaultHeaders);
    final response = await performRequest(request);
    return parseResponse<ItemType>(
        response: response,
        parseFunction: deleteParseFunction ?? updateParseFunction);
  }

  @override
  Future<RestRepositoryResult<ItemType>> delete(int id) async {
    _uriBuilder.path = defaultRoute ?? deleteRoute;
    final url = _uriBuilder.build().toString();
    final request = RestRepositoryRequest(
        url: url, httpMethod: 'DELETE', headers: defaultHeaders);
    final response = await performRequest(request);
    return parseResponse<ItemType>(
        response: response,
        parseFunction: defaultParseFunction ?? deleteParseFunction);
  }

  @override
  Future<RestRepositoryResponse> performRequest(
      RestRepositoryRequest request) async {
    if (request.headers == null) {
      request.headers = defaultHeaders;
    } else {
      for (final key in defaultHeaders.keys) {
        request.headers.putIfAbsent(key, () => defaultHeaders[key]);
      }
    }

    debugPrint('Performing request: ${request.toString()}');

    return _client.performRequest(request);
  }

  @override
  Future<RestRepositoryResult<ResponseType>> parseResponse<ResponseType>(
      {RestRepositoryResponse response, ItemCreator parseFunction}) async {
    debugPrint('Response: ${response.toString()}');

    if (successfullStatusCodes.contains(response.statusCode)) {
      if (parseFunction == null) {
        return RestRepositoryResult<ResponseType>(response: response);
      }

      final parsedObject = parseFunction(jsonDecode(response.body));
      return RestRepositoryResult<ResponseType>(
          response: response, value: parsedObject);
    } else {
      return RestRepositoryResult<ResponseType>(
        response: response,
        error: NetworkError(errorMsg: 'Something went wrong'),
      );
    }
  }

  Uri buildUri({
    @required String path,
    String scheme,
    String host,
    int port,
    Map<String, String> params = const <String, String>{},
  }) {
    final UriBuilder uriBuilder = UriBuilder();
    uriBuilder.scheme = scheme ?? networkConfig.apiScheme;
    uriBuilder.host = host ?? networkConfig.apiHost;
    uriBuilder.port = port ?? networkConfig.apiPort;
    uriBuilder.path = path;
    uriBuilder.queryParameters = params;
    return uriBuilder.build();
  }

  @override
  Map<String, String> get defaultHeaders {
    return {};
  }

  @override
  Set<int> get successfullStatusCodes {
    return StatusCodeConstants.successfulStatusCodes;
  }
}
