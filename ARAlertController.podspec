Pod::Spec.new do |s|
  s.name             = "ARAlertController"
  s.version          = "0.1.3"
  s.summary          = "UIAlertController compatible iOS >= 5.0"
  s.homepage         = "https://github.com/alexruperez/ARAlertController"
  s.screenshots      = "https://raw.githubusercontent.com/alexruperez/ARAlertController/master/alert8.png", "https://raw.githubusercontent.com/alexruperez/ARAlertController/master/alert7.png", "https://raw.githubusercontent.com/alexruperez/ARAlertController/master/sheet8.png", "https://raw.githubusercontent.com/alexruperez/ARAlertController/master/sheet7.png"
  s.license          = 'MIT'
  s.author           = { "alexruperez" => "contact@alexruperez.com" }
  s.source           = { :git => "https://github.com/alexruperez/ARAlertController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexruperez'

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'ARAlertController/ARAlertController.{h,m}'
	
  s.frameworks = 'UIKit'
end