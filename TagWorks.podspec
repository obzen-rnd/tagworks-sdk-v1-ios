#
# Be sure to run `pod lib lint TagWorks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TagWorks'
  s.version          = '1.0.7'
  s.summary          = 'TagWorks SDK for iOS'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Obzen TagWorks Mobile SDK for iOS'
  s.homepage         = 'https://obzen.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'obzen' => 'obzen-rnd@obzen.com' }
  s.source           = { :git => 'https://github.com/obzen-rnd/tagworks-sdk-v1-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/TagWorks/**/*'

end
