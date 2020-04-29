class PageMetadata {
  int defaultPageSize;
  int page;
  int totalCount;

  PageMetadata({this.defaultPageSize, this.page, this.totalCount});

  factory PageMetadata.fromJson(json) => PageMetadata(
      defaultPageSize: json['defaultPageSize'] as int,
      page: json['page'] as int,
      totalCount: json['totalCount'] as int);
}

class MPage<ItemType> {
  List<ItemType> data;
  PageMetadata metadata;

  MPage({this.data, this.metadata});
}

class RepositoryResult<ItemType> {
  final ItemType resultValue;
  final Error error;

  RepositoryResult({this.resultValue, this.error});
}

abstract class Repository<ItemType> {
  Future<RepositoryResult<MPage<ItemType>>> getPage(int page, int pageSize,
      [Map<String, String> queryParams]);

  Future<RepositoryResult<List<ItemType>>> getAll(
      [Map<String, String> queryParams]);

  Future<RepositoryResult<ItemType>> getOne(int id);

  Future<RepositoryResult<ItemType>> create(Map<String, dynamic> body);

  Future<RepositoryResult<ItemType>> update(
      dynamic id, Map<String, dynamic> body);

  Future<RepositoryResult<ItemType>> delete(int id);
}
