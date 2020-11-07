Pod::Spec.new do |s|
  s.name         = "TKit"
  s.version      = "0.6"
  s.summary      = "TKit is ios project"
  s.homepage     = "http://billoway.cn"
  s.author       = { "billoway" => "billoway@126.com" }
  s.source       = { :git => "./"}

  s.frameworks = 'CoreMotion', 'CoreText', 'CFNetwork', 'CoreData', 'CoreGraphics', 'ImageIO', 'MobileCoreServices', 'SystemConfiguration'
  s.library = 'xml2','z','icucore'

  s.platform     = :ios, '6.0'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '/usr/include/libxml2'}


  # ------  TRequest
  s.subspec 'TRequest' do |s0|
  s0.source_files = 'TKit/TRequest/*.{h,m,mm}','TKit/*.h'
  s0.public_header_files = 'TKit/TRequest/*.h','TKit/*.h'
  s0.preserve_paths = 'TKit/TRequest/*.{h}'
  s0.requires_arc = true

  s0.dependency 'SDWebImage'
  s0.dependency 'AFNetworking'
  s0.dependency 'Reachability'

  end

  # ------  TExt
  s.subspec 'TExt' do |s1|
  s1.source_files = 'TKit/TExt/**/*.{h,m,mm}'
  s1.public_header_files = 'TKit/TExt/**/*.h'
  s1.requires_arc = true

  s1.dependency 'NSDate-Extensions'
  s1.dependency 'GDataXML-HTML'
  s1.dependency 'GCJSONKit'

  end


  # ------  TWidget
  s.subspec 'TWidget' do |s2|
  s2.source_files = 'TKit/TWidget/*.{h,m,mm}'
  s2.public_header_files = 'TKit/TWidget/*.h'
  s2.resources = 'TKit/TWidget/PullToRefresh.bundle'
  s2.requires_arc = true

  end


end
