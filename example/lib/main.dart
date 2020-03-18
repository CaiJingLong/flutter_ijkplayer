import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/page/index.dart';
import 'package:oktoast/oktoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IjkManager.initIJKPlayer();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isInitPlugin = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      isInitPlugin = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitPlugin) {
      return Container();
    }
    return OKToast(
      child: MaterialApp(
        home: IndexPage(),
      ),
    );
  }
}
