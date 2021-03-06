#
# Be sure to run `pod lib lint BLKNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BLKNetwork'
  s.version          = '1.0.3'
  s.summary          = 'Network framework for blkee'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Network framework for blkee.
                       DESC

  s.homepage         = 'https://github.com/LiuHangqi/BLKNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiuHangqi' => 'liuhangqi@live.com' }
  s.source           = { :git => 'https://github.com/LiuHangqi/BLKNetwork.git', :tag => '1.0.3' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BLKNetwork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BLKNetwork' => ['BLKNetwork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking'
end
