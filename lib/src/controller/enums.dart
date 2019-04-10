part of '../ijkplayer.dart';

enum DataSourceType {
  network,
  file,
  asset,
}

/// Current IjkMedia status
enum IjkStatus {
  noDatasource,
  preparing,
  setDatasourceFail,
  prepared,
  pause,
  error,
  playing,
  complete,
  disposed,
}
