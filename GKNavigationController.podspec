Pod::Spec.new do |s|
  s.name  	 = "GKNavigationController"
  s.version      = "1.0.4"
  s.summary      = "自定义导航栏--导航栏联动"
  s.homepage     = "https://github.com/QuintGao/GKNavigationController"
  s.license      = "MIT"
  s.authors            = { "高坤" => "1094887059@qq.com" }
  s.social_media_url   = "https://github.com/QuintGao"
  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.source       = { :git => "https://github.com/QuintGao/GKNavigationController.git", :tag => s.version.to_s }
  s.source_files  = "GKNavigationController/**/*.{h,m}"
  s.public_header_files = "GKNavigationController/**/*.h"
  s.resource  = "GKNavigationController/Resource"
  s.frameworks = "Foundation", "UIKit"
end
