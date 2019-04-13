import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';

class CustomIjkOptionPage extends StatefulWidget {
  @override
  _CustomIjkOptionPageState createState() => _CustomIjkOptionPageState();
}

class _CustomIjkOptionPageState extends State<CustomIjkOptionPage> {
  IjkMediaController controller = IjkMediaController();

  @override
  void initState() {
    super.initState();
    initIjkController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.customOption),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1280 / 720,
            child: IjkPlayer(
              mediaController: controller,
            ),
          ),
        ],
      ),
    );
  }

  void initIjkController() async {
    var option1 = IjkOption(IjkOptionCategory.format, "fflags", "fastseek");

    controller.setIjkPlayerOptions(
      [TargetPlatform.iOS, TargetPlatform.android],
      [option1].toSet(),
    );

    await controller.setDataSource(
      DataSource.network(
          "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4"),
      autoPlay: true,
    );
  }
}
