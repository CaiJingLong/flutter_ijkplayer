import 'dart:convert';

/// about video info
class VideoInfo {
  /// Width of Video
  int width;

  /// Height of Video
  int height;

  /// Total length of video
  double duration;

  /// Current playback progress
  double currentPosition;

  /// In play
  bool isPlaying;

  /// Degree of Video
  int degree;

  /// The media tcp speed, unit is byte
  int tcpSpeed;

  Map<String, dynamic> _map;

  /// Percentage playback progress
  double get progress => (currentPosition ?? 0) / (duration ?? 1);

  ///Is there any information?
  bool get hasData => _map != null;

  /// Aspect ratio
  double get ratio {
    double r;
    if (width != null && height != null) {
      if (width == 0 || height == 0) {
        r = 1280 / 720;
      } else {
        r = width / height;
      }
    } else {
      r = 1280 / 720;
    }

    return r;
  }

  /// Constructing from the native method
  VideoInfo.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }
    this._map = map;
    this.width = map["width"];
    this.height = map["height"];
    this.duration = map["duration"];
    this.currentPosition = map["currentPosition"];
    this.isPlaying = map["isPlaying"];
    this.degree = map["degree"];
    this.tcpSpeed = map["tcpSpeed"];
  }

  @override
  String toString() {
    if (_map == null) {
      return "null";
    }
    return json.encode(_map);
  }
}
