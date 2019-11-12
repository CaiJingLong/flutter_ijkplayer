part of '../ijkplayer.dart';

/// Entity classe for data sources.
class DataSource {
  /// See [DataSourceType]
  DataSourceType _type;

  File _file;

  String _assetName;

  String _assetPackage;

  String _netWorkUrl;

  Map<String, String> _headers;

  DataSource._();

  /// Create file data source
  factory DataSource.file(File file) {
    var ds = DataSource._();
    ds._file = file;
    ds._type = DataSourceType.file;
    return ds;
  }

  /// Create network data source
  factory DataSource.network(String url,
      {Map<String, String> headers = const {}}) {
    var ds = DataSource._();
    ds._netWorkUrl = url;
    ds._headers = headers;
    ds._type = DataSourceType.network;
    return ds;
  }

  /// Create asset data source
  factory DataSource.asset(String assetName, {String package}) {
    var ds = DataSource._();
    ds._assetName = assetName;
    ds._assetPackage = package;
    ds._type = DataSourceType.asset;
    return ds;
  }
}
