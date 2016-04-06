
Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "MinCarouseView"
  s.version      = "1.0.2"
  s.summary      = "A image carouse View with swift."
  s.description  = <<-DESC
  					         swift版本，图片轮播器, 可以缓存网络图片、支持自动滚动, 需要iOS8.0以上版本
                   DESC

  s.homepage     = "https://github.com/zsmzhu/MinCarouseView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "zsm" => "zsmzhug@gmail.com" }
  # s.social_media_url   = "http://twitter.com/zsm"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform       = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/zsmzhu/MinCarouseView.git", :tag => "1.0.2" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = 'MinCarouseView/**/*.{swift}'
  
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.frameworks = 'Foundation', 'UIKit'

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

end
