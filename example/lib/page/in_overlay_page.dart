import 'package:flutter/material.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class InOverlayPage extends StatefulWidget {
  @override
  _InOverlayPageState createState() => _InOverlayPageState();
}

class _InOverlayPageState extends State<InOverlayPage> {
  IjkMediaController controller = IjkMediaController();
  OverlayEntry entry;

  @override
  void initState() {
    super.initState();
    controller.setDataSource(
      DataSource.network(
        "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4",
      ),
      autoPlay: true,
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    entry?.remove();
    entry = null;
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
        title: Text(currentI18n.overlayPageTitle),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            child: IjkPlayer(
              mediaController: controller,
            ),
            aspectRatio: 1,
          ),
          FlatButton(
            child: Text("showInOverlay"),
            onPressed: showInOverlay,
          ),
        ],
      ),
    );
  }

  void showInOverlay() {
    entry = OverlayEntry(builder: (BuildContext context) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 200,
          child: AspectRatio(
            aspectRatio: 1,
            child: IjkPlayer(
              mediaController: controller,
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(entry);
  }
}
