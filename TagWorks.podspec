#
# Be sure to run `pod lib lint TagWorks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TagWorks'
  s.version          = '0.1.1'
  s.summary          = 'TagWorks SDK for iOS'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Obzen TagWorks Mobile SDK for iOS'
  s.homepage         = 'https://support.obzen.com/Obzen/TagWorks-SDK-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '68175154' => 'hanyj96@obzen.com' }
  s.source           = { :git => 'https://support.obzen.com/Obzen/TagWorks-SDK-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/TagWorks/**/*'

end
