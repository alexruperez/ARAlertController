Pod::Spec.new do |s|
  s.name             = "ARAlertController"
  s.version          = "0.1.0"
  s.summary          = "UIAlertController compatible iOS >= 5.0"
  s.homepage         = "https://github.com/alexruperez/ARAlertController"
  s.screenshots      = "https://www.service2media.com/wp-content/uploads/2014/08/UIAlertControl.png"
  s.license          = 'MIT'
  s.author           = { "alexruperez" => "contact@alexruperez.com" }
  s.source           = { :git => "https://github.com/alexruperez/ARAlertController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexruperez'

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'ARAlertController/ARAlertController.{h,m}'
	
  s.frameworks = 'UIKit'
end