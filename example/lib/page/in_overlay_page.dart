import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

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
    OptionUtils.addDefaultOptions(controller);
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

  void showInOverlay() async {
    var info = await controller.getVideoInfo();
    OverlayEntry _entry;
    _entry = OverlayEntry(
      builder: (BuildContext context) {
        return OverlayWidget(
          controller: controller,
          initVideoInfo: info,
          onTapClose: () {
            _entry?.remove();
          },
        );
      },
    );
    Overlay.of(context).insert(_entry);
  }
}

class OverlayWidget extends StatefulWidget {
  final VideoInfo initVideoInfo;
  final IjkMediaController controller;
  final Function onTapClose;

  const OverlayWidget({
    Key key,
    this.initVideoInfo,
    this.controller,
    this.onTapClose,
  }) : super(key: key);

  @override
  _OverlayWidgetState createState() => _OverlayWidgetState();
}

const double _overlayWidth = 200;

class _OverlayWidgetState extends State<OverlayWidget> {
  double dx = 0;
  double dy = 1;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OffsetNotication>(
      onNotification: _onOffsetNoticiation,
      child: Align(
        alignment: Alignment(dx, dy),
        child: Container(
          width: _overlayWidth,
          child: AspectRatio(
            aspectRatio: widget.initVideoInfo.ratio,
            child: IjkPlayer(
              mediaController: widget.controller,
              controllerWidgetBuilder: (ctl) {
                return OverlayControllerWidget(
                  controller: ctl,
                  onTapClose: widget.onTapClose,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Offset _startOffset;

  bool _onOffsetNoticiation(OffsetNotication notification) {
    if (notification.type == OffsetType.start) {
      _startOffset = Offset(dx, dy);
      return true;
    }

    var offset = notification.offset;

    var size = MediaQuery.of(context).size;

    dx = _startOffset.dx + offset.dx / size.width * 2;
    dy = _startOffset.dy + offset.dy / size.height * 2;

    print("dx = $dx");
    print("dy = $dy");

    if (dx > 1) {
      dx = 1;
    } else if (dx < -1) {
      dx = -1;
    }

    if (dy > 1) {
      dy = 1;
    } else if (dy < -1) {
      dy = -1;
    }

    setState(() {});
    return true;
  }
}

class OverlayControllerWidget extends StatefulWidget {
  final IjkMediaController controller;
  final Function onTapClose;

  const OverlayControllerWidget({
    Key key,
    this.controller,
    this.onTapClose,
  }) : super(key: key);

  @override
  _OverlayControllerWidgetState createState() =>
      _OverlayControllerWidgetState();
}

class _OverlayControllerWidgetState extends State<OverlayControllerWidget> {
  bool showController = false;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (!showController) {
      child = Container();
    } else {
      child = Container(
        color: Colors.black.withOpacity(0.6),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.close),
              onPressed: widget.onTapClose,
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      child: child,
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => showController = !showController),
      // onPanUpdate: (detail) {
      //   var notification = OffsetNotication()
      //     ..offset = detail.delta
      //     ..type = OffsetType.update;
      //   notification.dispatch(context);
      // },

      // onPanStart: (detail) {
      //   var notication = OffsetNotication()..type = OffsetType.start;
      //   notication.dispatch(context);
      // },
      onLongPressMoveUpdate: (detail) {
        var notification = OffsetNotication()
          ..offset = detail.offsetFromOrigin
          ..type = OffsetType.update;
        notification.dispatch(context);
      },
      onLongPressStart: (detail) {
        var n = OffsetNotication()..type = OffsetType.start;
        n.dispatch(context);
      },
    );
  }
}

class OffsetNotication extends Notification {
  Offset offset;

  OffsetType type;
}

enum OffsetType {
  start,
  update,
}
