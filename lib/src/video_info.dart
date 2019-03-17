import 'dart:convert';

class VideoInfo {
  int width;
  int height;
  double duration;
  double currentPosition;
  bool isPlaying;

  Map<String, dynamic> _map;

  double get radio => width / height;

  double get progress => (currentPosition ?? 0) / (duration ?? 1);

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
  }

  @override
  String toString() {
    if (_map == null) {
      return "null";
    }
    return json.encode(_map);
  }
}
