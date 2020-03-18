import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

class IjkStatusPage extends StatefulWidget {
  @override
  _IjkStatusPageState createState() => _IjkStatusPageState();
}

class _IjkStatusPageState extends State<IjkStatusPage> {
  TextEditingController editingController = TextEditingController();
  IjkMediaController mediaController = IjkMediaController();

  @override
  void initState() {
    super.initState();
    editingController.text =
        "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4";
        OptionUtils.addDefaultOptions(mediaController);
  }

  @override
  void dispose() {
    editingController.dispose();
    mediaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.ijkStatusTitle),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: editingController,
                ),
              ),
              FlatButton(
                child: Text(currentI18n.play),
                onPressed: _playInput,
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 12 / 7,
            child: buildIjkPlayer(),
          ),
        ],
      ),
    );
  }

  void _playInput() async {
    var text = editingController.text;
    await mediaController.setNetworkDataSource(text, autoPlay: true);
  }

  Widget buildIjkPlayer() {
    return IjkPlayer(
      mediaController: mediaController,
      statusWidgetBuilder: _buildStatusWidget,
    );
  }

  Widget _buildStatusWidget(
    BuildContext context,
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.noDatasource) {
      return Center(
        child: Text(
          "no data",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // you can custom your self status widget
    return IjkStatusWidget.buildStatusWidget(context, controller, status);
  }
}
