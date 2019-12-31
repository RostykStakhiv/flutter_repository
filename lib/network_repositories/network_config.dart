import 'package:flutter/cupertino.dart';
import 'package:uri/uri.dart';

class NetworkConfig {
  final String apiHost;
  final String apiScheme;
  final int apiPort;

  NetworkConfig(
      {@required this.apiHost, @required this.apiScheme, this.apiPort});

  String get baseUrl {
    final UriBuilder _uriBuilder = UriBuilder();
    _uriBuilder.scheme = apiScheme;
    _uriBuilder.host = apiHost;
    _uriBuilder.port = apiPort;
    return _uriBuilder.build().toString();
  }
}
