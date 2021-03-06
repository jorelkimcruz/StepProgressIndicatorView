#
# Be sure to run `pod lib lint StepProgressIndicatorView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StepProgressIndicatorView'
  s.version          = '0.0.1'
  s.summary          = 'Easy step progress indicator view'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    'Easy step progress indicator view with icons'
                       DESC
  s.swift_version = '4.2'
  s.homepage         = 'https://github.com/jorelkimcruz/StepProgressIndicatorView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jorel Cruz' => 'jorelkim.cruz@gmail.com' }
  s.source           = { :git => 'https://github.com/jorelkimcruz/StepProgressIndicatorView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/iJorelCruz'

  s.ios.deployment_target = '8.0'

  s.source_files = 'StepProgressIndicatorView/**/*'
  
  # s.resource_bundles = {
  #   'StepProgressIndicatorView' => ['StepProgressIndicatorView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
