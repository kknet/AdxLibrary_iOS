#
# Be sure to run `pod lib lint ADXLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ADXLibrary'
  s.version          = '1.0.1'
  s.summary          = 'ADX Library for iOS'
  s.description      = <<-DESC
ADX Library for iOS
                       DESC

  s.homepage         = 'https://github.com/adxcorp/AdxLibrary_iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chiung Choi' => 'god@adxcorp.kr' }
  s.source           = { :git => 'https://github.com/adxcorp/AdxLibrary_iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ADXLibrary/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ADXLibrary' => ['ADXLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.ios.vendored_frameworks =   'ADXLibrary/Dependencies/FBAudienceNetwork.framework',
                                'ADXLibrary/Dependencies/MobFoxSDKCore.framework',
                                'ADXLibrary/Dependencies/MVSDK.framework',
                                'ADXLibrary/Dependencies/MVSDKAppWall.framework'

  s.dependency 'mopub-ios-sdk'
  s.dependency 'Firebase/AdMob'
  s.dependency 'Firebase/AdMob'

  s.library       = 'z', 'sqlite3', 'xml2'
end
