require "json"

package = JSON.parse(File.read(File.join(__dir__, '..', "package.json")))

Pod::Spec.new do |s|
  s.name           = "ExpoNativeAlipay"
  s.version        = package["version"]
  s.summary        = package["description"]
  s.description    = package["description"]
  s.license        = package["license"]
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.platforms      = { :ios => "13.0" }  # ⚠️ 建议提升到 13.0（支付宝 SDK 要求）
  s.swift_version  = '5.9'
  s.source         = { :path => "." }
  s.static_framework = true

  s.dependency "ExpoModulesCore"
  s.resources = 'AlipaySDK.bundle'
  s.vendored_frameworks = 'AlipaySDK.framework'

  s.frameworks = ["UIKit", "Foundation", "CFNetwork", "SystemConfiguration", "QuartzCore", "CoreGraphics", "CoreMotion", "CoreTelephony", "CoreText", "WebKit"]
  s.libraries = ["c++", "z"]

  # 🔑 关键修复：添加模拟器架构排除配置
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule',
    # 排除模拟器的 arm64 架构（支付宝 SDK 不支持模拟器 arm64）
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'x86_64'
  }

  s.source_files = "*.{h,m,swift}"

  # 🔑 额外修复：确保 AlipaySDK.framework 也应用架构排除
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
end
