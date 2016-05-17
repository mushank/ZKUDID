
Pod::Spec.new do |s|
  s.name     = 'ZKUDIDManager'
  s.version  = '1.0.2'
  s.license  = 'MIT'
  s.summary  = 'Generate and manage persistent UDID(Unique Device Identifier) with IDFV(identifierForVendor) and keychain in iOS device.'
  s.homepage = 'https://github.com/mushank/ZKUDIDManager'
  s.author   = { 'Jack' => 'mushank@Gmail.com' }
  s.source   = { :git => 'https://github.com/mushank/ZKUDIDManager.git', :tag => s.version }
  s.platform = :ios, "6.0"  
  s.source_files = 'ZKUDIDManager/*.{h,m}'
  s.framework = 'UIKit'
  s.requires_arc = true  
end