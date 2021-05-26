import 'package:meta/meta.dart';

import '../repository.dart';
export '../repository.dart';

typedef S ItemCreator<S>(Map<String, dynamic> json);

class NetworkError extends Error {
  int errorCode;
  String type;
  final String errorMsg;
  final String errorTitle;

  NetworkError(
      {@required this.errorMsg,
      this.type,
      this.errorTitle = 'Something went wrong',
      this.errorCode});
}

class RestRepositoryResult<ItemType> extends RepositoryResult<ItemType> {
  final dynamic response;

  RestRepositoryResult(
      {@required this.response, ItemType value, NetworkError error})
      : super(resultValue: value, error: error);
}

class RestRepositoryRequest {
  final String url;
  final String httpMethod;
  final Map<String, dynamic> body;
  Map<String, String> headers = {};

  RestRepositoryRequest(
      {@required this.url, @required this.httpMethod, this.body, this.headers});

  @override
  String toString() {
    final bodyStr = body != null ? 'Body: ${body.toString()}\n' : '';
    final headersStr = headers != null ? 'Headers: ${headers.toString()}' : '';

    return 'url: $url\nMethod: $httpMethod\n$bodyStr$headersStr';
  }
}

class RestRepositoryResponse {
  final int statusCode;
  final Map<String, String> headers;
  final String body;

  RestRepositoryResponse({@required this.statusCode, this.headers, this.body});

  @override
  String toString() {
    final headersStr =
        headers != null ? 'Headers: ${headers.toString()}\n' : '';
    final bodyStr = body != null ? 'Body: ${body.toString()}\n' : '';

    return 'Status code: ${statusCode.toString()}\n$headersStr$bodyStr';
  }
}

abstract class RestRepository<ItemType> implements Repository<ItemType> {
  String get getAllRoute;
  String get getOneRoute;
  String get createRoute;
  String get updateRoute;
  String get deleteRoute;

  String get defaultRoute;

  ItemCreator get defaultParseFunction;

  ItemCreator get getAllParseFunction;
  ItemCreator get getOneParseFunction;
  ItemCreator get createParseFunction;
  ItemCreator get updateParseFunction;
  ItemCreator get deleteParseFunction;

  Map<String, String> get defaultHeaders;
  Set<int> get successfullStatusCodes;

  Future<RestRepositoryResponse> performRequest(RestRepositoryRequest request);
  Future<RestRepositoryResult<ResponseType>> parseResponse<ResponseType>(
      {@required RestRepositoryResponse response,
      @required ItemCreator parseFunction});
}
