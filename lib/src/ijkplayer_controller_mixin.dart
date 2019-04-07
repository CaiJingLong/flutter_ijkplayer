import 'package:flutter/material.dart';

mixin IjkMediaControllerMixin {
  List<GlobalKey> _keys = [];

  attach(GlobalKey key) {
    print("IjkMediaControllerMixin attach $key");
    _keys.add(key);
  }

  detach(GlobalKey key) {
    print("IjkMediaControllerMixin detach $key");
    _keys.remove(key);
  }
}
