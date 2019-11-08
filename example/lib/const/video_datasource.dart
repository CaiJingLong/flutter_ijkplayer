import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class VideoDataSource {
  static final springBootMenuM3u8 = DataSource.network(
      "https://media001.geekbang.org/f433fd1ce5e84d27b1101f0dad72a126/de563bb4aba94b5f95f448b33be4dd9f-9aede6861be944d696fe365f3a33b7b4-sd.m3u8");

  static final ai = DataSource.network(
      "http://img.ksbbs.com/asset/Mon_1703/05cacb4e02f9d9e.mp4");

  static final reportErrorM3u8FromAliyun = DataSource.network(
      "https://outin-4839d24d670f11e988c600163e1a3b4a.oss-cn-shanghai.aliyuncs.com/2b9f4f2d1c4d4985a11352cb1970fead/86c3f36ed4e1cd5539ed347282725b3e-fd-encrypt-stream.m3u8?Expires=1563162783&OSSAccessKeyId=LTAIrkwb21KyGjJl&Signature=y4m98BAzJUQVzFwHszQS%2BFGtq5A%3D");
}
