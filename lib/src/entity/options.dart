/// see [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer)
enum IjkOptionCategory {
  format,
  codec,
  sws,
  player,
}

/// see [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer)
class IjkOption {
  /// see [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer)
  final IjkOptionCategory category;

  /// see [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer)
  final String key;

  /// see [bilibili/ijkplayer](https://github.com/bilibili/ijkplayer)
  final dynamic value;

  IjkOption(this.category, this.key, this.value);

  /// to map
  Map<String, dynamic> toMap() {
    return {
      "category": category.index,
      "key": key,
      "value": value,
    };
  }

  @override
  int get hashCode => category.hashCode + key.hashCode;

  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other == null) {
      return false;
    }
    if (other is! IjkOption) {
      return false;
    }
    return this.category == other.category && this.key == other.key;
  }

  @override
  String toString() {
    return 'IjkOption{category: $category, key: $key, value: $value}';
  }
}
