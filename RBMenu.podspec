Pod::Spec.new do |s|
  s.name         = 'RBMenu'
  s.summary      = 'RBMenu.'
  s.version      = '1.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Ruibin.Chow' => 'ruibin.chow@qq.com' }
  s.social_media_url = 'http://www.zruibin.cc'
  s.homepage     = 'https://github.com/zruibin/RBMenu.git'
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source       = { :git => 'https://github.com/zruibin/RBMenu.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'RBMenu/*.{h,m}' #/**/*
  s.public_header_files = 'RBMenu/*.{h}'
  
  s.frameworks = 'UIKit', 'CoreFoundation', 'Foundation'

end

# a{bb,bc}def.{h,m}表示四个文件abbdef.h abbdef.m abcdef.h abcdef.m
# *.{h,m,mm}表示所有的.h .m .mm文件
# Class/**/*.{h,m}表示Class目录下的所有.h .m文