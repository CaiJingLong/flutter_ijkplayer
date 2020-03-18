import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class OptionUtils {
  static void addDefaultOptions(IjkMediaController controller) {
    controller.addIjkPlayerOptions(
      [TargetPlatform.iOS, TargetPlatform.android],
      createIJKOptions(),
    );
  }

  static Set<IjkOption> createIJKOptions() {
    return <IjkOption>[
      IjkOption(IjkOptionCategory.player, "mediacodec", 1),
      IjkOption(IjkOptionCategory.player, "mediacodec-hevc", 1),
      IjkOption(IjkOptionCategory.player, "videotoolbox", 1),
      IjkOption(IjkOptionCategory.player, "opensles", 0),
      IjkOption(IjkOptionCategory.player, "overlay-format", 0x32335652),
      IjkOption(IjkOptionCategory.player, "framedrop", 1),
      IjkOption(IjkOptionCategory.player, "start-on-prepared", 0),
      IjkOption(IjkOptionCategory.format, "http-detect-range-support", 0),
      IjkOption(IjkOptionCategory.codec, "skip_loop_filter", 48),
    ].toSet();
  }
}
