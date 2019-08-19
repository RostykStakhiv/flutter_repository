import 'package:flutter/cupertino.dart';

class NetworkConfig {
  final String apiHost;
  final String apiScheme;
  final int apiPort;

  NetworkConfig(
      {@required this.apiHost, @required this.apiScheme, this.apiPort});
}
