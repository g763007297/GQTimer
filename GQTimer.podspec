Pod::Spec.new do |s|

  s.name         = "GQTimer"
  s.version      = "1.0.0"
  s.summary      = "定时器"

  s.homepage     = "https://github.com/g763007297/GQTimer"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "developer_高" => "763007297@qq.com" }
  
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/g763007297/GQTimer.git" , :tag => s.version}

  s.requires_arc = true

  s.source_files = "GQImageDownloader/**/*.{h,m}"

end
