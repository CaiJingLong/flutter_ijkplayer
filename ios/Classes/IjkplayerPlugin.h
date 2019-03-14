#import <Flutter/Flutter.h>

@interface IjkplayerPlugin : NSObject<FlutterPlugin>

@property(nonatomic, strong) NSObject <FlutterPluginRegistrar> *registrar;

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

+ (instancetype)pluginWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar;

+ (instancetype)sharedInstance;


@end
