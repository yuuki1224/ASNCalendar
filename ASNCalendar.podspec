#
#  Be sure to run `pod spec lint ASNCalendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name          = "ASNCalendar"
  s.version       = "0.0.1"
  s.summary       = "A simple calendar."
  s.description   = "ASNCalendar can be userd to infinitely swipe."
  s.homepage      = "https://github.com/yuuki1224/ASNCalendar"
  s.screenshots   = "https://raw.githubusercontent.com/yuuki1224/ASNCalendar/master/ASNCalendar.gif"
  s.license       = "MIT"
  s.author        = { "YukiAsano" => "yuuki.1224.softtennis@gmail.com" }
  s.platform      = :ios, "7.0"
  s.source        = { :git => "https://github.com/yuuki1224/ASNCalendar", :tag => s.version.to_s }
  s.source_files  = "Classes"
end
