#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint waterbus_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'waterbus_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin of Waterbus.'
  s.description      = <<-DESC
  Flutter plugin of Waterbus.
                       DESC
  s.homepage         = 'https://docs.waterbus.tech'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'lambiengcode' => 'lambiengcode@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'waterbus_callkit_incoming', '0.0.2'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
