import 'dart:convert';

class VideoInfo {
  int width;
  int height;
  double duration;
  double currentPosition;
  bool isPlaying;
  int degree;

  Map<String, dynamic> _map;

  double get radio => width / height;

  double get progress => (currentPosition ?? 0) / (duration ?? 1);

  bool get hasData => _map != null;

  double get ratio {
    double r;
    if (width != null && height != null) {
      r = width / height;
    } else {
      r = 1280 / 720;
    }

    return r;
  }

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
  }

  @override
  String toString() {
    if (_map == null) {
      return "null";
    }
    return json.encode(_map);
  }
}
