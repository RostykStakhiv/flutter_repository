import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_repository/clients/rest/rest_repository_client.dart';
import 'package:flutter_repository/flutter_repository.dart';

import 'package:http/http.dart' as http;

class HttpRestRepositoryClient implements RestRepositoryClient {
  final http.Client httpClient;

  HttpRestRepositoryClient({@required this.httpClient});

  @override
  Future<RestRepositoryResponse> performRequest(RestRepositoryRequest request) async {
    var httpRequest = http.Request(request.httpMethod, Uri.parse(request.url));

    if(request.body != null) {
      httpRequest.body = jsonEncode(request.body);
    }

    if(request.headers != null) {
      httpRequest.headers.addAll(request.headers);
    }
    
    final response = await httpClient.send(httpRequest);
    final body = await response.stream.bytesToString();
    return RestRepositoryResponse(statusCode: response.statusCode, headers: response.headers, body: body);
  }
}