import 'package:flutter_repository/flutter_repository.dart';

abstract class RestRepositoryClient {
  Future<RestRepositoryResponse> performRequest(RestRepositoryRequest request);
}