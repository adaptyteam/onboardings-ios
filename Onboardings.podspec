Pod::Spec.new do |s|
  s.name             = 'Onboardings'
  s.version          = '1.0.0-beta.1'
  s.summary          = 'Onboardings SDK for iOS.'

  s.description      = <<-DESC
Onboardings SDK for iOS.
                       DESC

  s.homepage         = 'https://adapty.io/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adapty' => 'contact@adapty.io' }
  s.source           = { :git => 'https://github.com/adaptyteam/onboardings-ios', :tag => s.version.to_s }
  s.documentation_url = "https://docs.adapty.io"

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.9'

  s.source_files = 'Sources/**/*.swift'
  s.resource_bundles = {"Onboardings" => ["Sources/PrivacyInfo.xcprivacy"]}

  s.ios.framework = 'UIKit'

  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS' => '-package-name io.adapty.onboardings'
  }
end
