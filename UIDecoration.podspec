#
# Be sure to run `pod lib lint UIDecoration.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIDecoration'
  s.version          = '0.1.2'
  s.summary          = 'a swift framework to help create view decoration'
  s.homepage         = 'https://github.com/aonliu/UIDecoration.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aonliu' => '3243629382@qq.com' }
  s.source           = { :git => 'https://github.com/aonliu/UIDecoration.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.source_files = 'UIDecoration/**/*'
  s.swift_versions = ['5.0']
end
