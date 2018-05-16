#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ValidModel'
  s.version          = '0.1.0'

  s.swift_version = '4.1'
  s.platform     = :ios, '11.0'
  s.ios.deployment_target = '11.0'

  s.summary          = 'ValidModel empowers model validation and autogeneration.'
  s.description      = <<-DESC
ValidModel enhances application models and makes data safer to handle and easier to reason about.

In many cases projects are stuffed with 'mocks'. They provide good value
however it comes with a price of extra development and maintanence that mock loading system
and mock files require (source code that loads mock data, mock data files that are supposed to match model's format).

In a nutshell ValidModel proposes a different workflow when working with application models and it boils down to an ideas of Validation.
Assume having a model with clearly defined min-max range values for the properties of the model.
By just knowing min-max limits information it is easy to:
  - confirm that given model instance contains correct values that application knows how to deal with.
  - generate new instance of this model for easy testing, N times (whether you work on UI edge case or API is not available, it is just like an object from mock data, but autogenerated, N times).
                       DESC

  s.homepage         = 'https://github.com/ReImpl/ValidModel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kernel' => 'kernel@reimplement.mobi' }
  s.source           = { :git => 'https://github.com/ReImpl/ValidModel.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  # s.source_files = "ValidModel/Classes/*.{swift}"

  s.subspec 'Base' do |base|
    base.source_files = "ValidModel/Classes/Base/**/*.{swift}"
  end

  s.subspec 'Extended' do |ext|
    ext.dependency 'ValidModel/Base'
    ext.dependency 'Fakery'

    ext.source_files  = "ValidModel/Classes/Extended/**/*.{swift}"
  end
  
  # s.resource_bundles = {
  #   'ValidModel' => ['ValidModel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
end
