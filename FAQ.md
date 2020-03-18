# FAQ

## iOS

### About get cocoapod error

Q: Use the 0.2.3 version of FlutterIJK error in iOS.
A: Use next method:

```bash
pod cache clean FlutterIJK
```

Remove your FlutterIJK version.
And rerun `pod install`
