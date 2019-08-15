#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ijkplayer'
  s.version          = '0.0.1'
  s.summary          = 'IjkPlayer plugin for flutter'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Caijinglong' => 'cjl_spy@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*' , 'IJKMediaFramework.framework'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.static_framework = true
  s.ios.deployment_target = '8.0'

  # s.ios.vendored_frameworks = 'IJKMediaFramework.framework'
  # s.frameworks  = "AudioToolbox", "AVFoundation", "CoreGraphics", "CoreMedia", "CoreVideo", "MobileCoreServices", "OpenGLES", "QuartzCore", "VideoToolbox", "Foundation", "UIKit", "MediaPlayer"
  # s.libraries   = "bz2", "z", "stdc++"
  s.dependency 'FlutterIJK', '~> 0.1.0'

  # s.script_phase = {:name => 'extract framework', :script=> 'echo "Hello World"; pwd' ,:execution_position => :before_compile}

end

