import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:ijkplayer_example/i18n/i18n.dart';
import 'package:ijkplayer_example/utils/options_utils.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo/photo.dart';

class PagingPickPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentI18n.pick),
      ),
      body: ListView(
        children: <Widget>[
          FlatButton(
            child: Text(currentI18n.pick),
            onPressed: () => pickVideo(context),
          ),
        ],
      ),
    );
  }

  pickVideo(BuildContext context) async {
    var photos = await PhotoPicker.pickAsset(
      context: context,
      maxSelected: 8,
      pickType: PickType.onlyVideo,
    );

    if (photos == null || photos.isEmpty) {
      showToast(currentI18n.noPickTip);
      return;
    }

    showDialog(
      context: context,
      builder: (_) => buildLoadingWidget(),
    );

    List<DataSource> dataSourceList = [];
    for (var photo in photos) {
      var file = await photo.file;
      dataSourceList.add(DataSource.file(file));
    }

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PagingPage(
          dataSourceList: dataSourceList,
        ),
      ),
    );
  }
}

Widget buildLoadingWidget() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      width: 80,
      height: 80,
      padding: EdgeInsets.all(22),
      child: CircularProgressIndicator(),
    ),
  );
}

class PagingPage extends StatefulWidget {
  final List<DataSource> dataSourceList;

  const PagingPage({
    Key key,
    this.dataSourceList,
  }) : super(key: key);

  @override
  _PagingPageState createState() => _PagingPageState();
}

class _PagingPageState extends State<PagingPage> {
  Map<DataSource, IjkMediaController> map = {};
  @override
  void initState() {
    super.initState();
    assert(widget.dataSourceList != null);
    assert(widget.dataSourceList.isNotEmpty);
    initFirst();
  }

  void initFirst() async {
    await Future.delayed(Duration(seconds: 1));
    getControllerWithSrc(widget.dataSourceList[0])?.play();
  }

  @override
  void dispose() {
    _disposeAllCtl();
    super.dispose();
  }

  _disposeAllCtl() {
    for (var ctl in map.values) {
      ctl?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.dataSourceList != null);

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: _buildItem,
      itemCount: widget.dataSourceList.length,
      onPageChanged: (current) {
        print("current page = $current");
        var src = widget.dataSourceList[current];
        var ctl = getControllerWithSrc(src);
        ctl?.pauseOtherController();
        ctl?.seekTo(0);
        ctl?.play();
      },
    );
  }

  // Hold up to three controllers.
  // IjkMediaController initControllers(int current) {
  //   var src = widget.dataSourceList[current];
  //   var ctl = getControllerWithSrc(src);

  //   var next = current + 1;
  //   if (next < widget.dataSourceList.length) {
  //     var datasource = widget.dataSourceList[next];
  //     var nextCtl = getControllerWithSrc(datasource);
  //   }

  //   return ctl;
  // }

  // void disposeOther(int current) {
  //   var last = current - 1;
  //   var next = current + 1;
  // }

  Widget _buildItem(BuildContext context, int index) {
    var src = widget.dataSourceList[index];
    var ctl = getControllerWithSrc(src);
    return IjkPlayer(
      mediaController: ctl,
      controllerWidgetBuilder: (_) => Container(),
    );
  }

  IjkMediaController getControllerWithSrc(DataSource src) {
    var ctl = map[src];
    if (ctl == null) {
      ctl = IjkMediaController();
      OptionUtils.addDefaultOptions(ctl);
      map[src] = ctl;
      ctl.setDataSource(src, autoPlay: false);
    }
    return ctl;
  }
}
