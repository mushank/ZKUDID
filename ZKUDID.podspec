
Pod::Spec.new do |s|
  s.name     = 'ZKUDID'
  s.version  = '2.0'
  s.license  = 'MIT'
  s.summary  = 'Generate and save permanent UDID with IDFV and keychain in iOS device.'
  s.homepage = 'https://github.com/mushank/ZKUDID'
  s.author   = { 'Jack' => 'mushank@Gmail.com' }
  s.source   = { :git => 'https://github.com/mushank/ZKUDID.git', :tag => s.version }
  s.platform = :ios, "6.0"  
  s.source_files = 'ZKUDID/*.{h,m}'
  s.framework = 'UIKit'
  s.requires_arc = true  
end