# ijkplayer

ijkplayer,通过内接纹理的方式接入 bilibili/ijkplayer

## 目前进度

- [ ]参考 video_player 设计 api，以保证 video_player 无缝切换到 ijkplayer

### dart

- [ ] 重构代码，参考 video_player

### android

- [x] 重新编译 ijkplayer,支持 https
- [ ] 重构 android 代码，参照 video_player

### ios

- [x] 重新编译 ijkplayer,支持 https
- [x] 使用 pod 依赖而不是直接将库放入仓库内
- [ ] 使用静态库以支持 swift
- [ ] 重构代码，参考 video_player
