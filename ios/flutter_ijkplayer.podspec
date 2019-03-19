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

  s.ios.deployment_target = '8.0'

  s.dependency 'FlutterIJK', '~> 0.0.6'

end

