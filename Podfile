project 'xcprotobuf.xcodeproj'

platform :ios, '14.0'

target 'xcprotobuf' do
  use_frameworks!

  pod 'Protobuf-C++', '~> 3.21'
end

post_install do |installer|
  for f in Dir.glob("Pods/Target Support Files/Protobuf-C++/**") do
    text = File.read(f) 
    content = text.gsub(/<UIKit\/UIKit.h>/, "<Foundation/Foundation.h>")
    File.open(f, "w") { |file| file << content }
  end

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['HEADER_SEARCH_PATHS'] = 'Protobuf-C++/src'
      config.build_settings['MACH_O_TYPE'] = ENV['MACH_O_TYPE'] || 'mh_dylib' # 'staticlib'  #'mh_dylib'
      config.build_settings['OTHER_CFLAGS'] = '-fgnu-inline-asm' # for apple watch
    end
  end
end
