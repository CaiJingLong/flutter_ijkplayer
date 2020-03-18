import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';

class SpeedPage extends StatefulWidget {
  @override
  _SpeedPageState createState() => _SpeedPageState();
}

class _SpeedPageState extends State<SpeedPage> {
  IjkMediaController controller = IjkMediaController();

  double speed = 1;

  @override
  void initState() {
    super.initState();
    var url = "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4";
    var dataSource = DataSource.network(url);

    OptionUtils.addDefaultOptions(controller);
    controller?.setDataSource(dataSource, autoPlay: true);
  }

  @override
  void dispose() {
    controller.dispose();
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.setSpeed),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              height: 280,
              child: IjkPlayer(
                mediaController: controller,
              ),
            ),
            Slider(
              value: speed,
              max: 2,
              min: 0.5,
              divisions: 6,
              onChanged: _onChangeSpeed,
            ),
            Center(child: Text("speed is $speed")),
          ],
        ),
      ),
    );
  }

  void _onChangeSpeed(double value) {
    this.speed = value;
    setState(() {});
    controller?.setSpeed(speed);
  }
}
