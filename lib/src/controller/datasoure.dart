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

  String _mediaUrl;

  DataSource._();

  /// Create file data source
  factory DataSource.file(File file) {
    final ds = DataSource._();
    ds._file = file;
    ds._type = DataSourceType.file;
    return ds;
  }

  /// Create network data source
  factory DataSource.network(String url,
      {Map<String, String> headers = const {}}) {
    final ds = DataSource._();
    ds._netWorkUrl = url;
    ds._headers = headers;
    ds._type = DataSourceType.network;
    return ds;
  }

  /// Create asset data source
  factory DataSource.asset(String assetName, {String package}) {
    final ds = DataSource._();
    ds._assetName = assetName;
    ds._assetPackage = package;
    ds._type = DataSourceType.asset;
    return ds;
  }

  /// Create for [photo_manager](https://pub.dev/packages/photo_manager) library. [AssetEntity.mediaUrl]
  factory DataSource.photoManagerUrl(String mediaUrl) {
    final ds = DataSource._();
    ds._mediaUrl = mediaUrl;
    ds._type = DataSourceType.photoManager;
    return ds;
  }
}
