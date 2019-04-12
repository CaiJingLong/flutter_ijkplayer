enum IjkOptionCategory {
  format,
  codec,
  sws,
  player,
}

class IjkOption {
  final IjkOptionCategory category;
  final String key;
  final dynamic value;

  IjkOption(this.category, this.key, this.value);

  Map<String, dynamic> toMap() {
    return {
      "category": category.index,
      "key": key,
      "value": value,
    };
  }
}
