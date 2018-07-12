#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ValidModel'
  s.version          = '0.1.8'

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  # dependency 'Fakery' is not supported on WatchOS.
  #s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = "9.0"

  s.summary          = 'ValidModel empowers model validation and autogeneration.'
  s.description      = <<-DESC
ValidModel enhances application models and makes data safer to handle and easier to reason about.

It provides a programming model that can:
  - confirm that given model instance contains correct values that application knows how to deal with.
  - generate new instance(s) of a model for easy testing, N times (whether you work on UI edge case or API is not available, it is just like an object from mock data, but autogenerated, N times).
                       DESC

  s.homepage         = 'https://github.com/ReImpl/ValidModel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kernel' => 'kernel@reimplement.mobi' }
  s.source           = { :git => 'https://github.com/ReImpl/ValidModel.git', :tag => s.version.to_s }

  # s.source_files = "ValidModel/Classes/*.{swift}"

  s.subspec 'Base' do |base|
    base.source_files = "ValidModel/Classes/Base/**/*.{swift}"
  end

  s.subspec 'Extended' do |ext|
    ext.dependency 'ValidModel/Base'
    ext.dependency 'Fakery'

    ext.source_files  = "ValidModel/Classes/Extended/**/*.{swift}"
  end


  s.swift_version = '4.2'
  s.requires_arc = true
  
end
