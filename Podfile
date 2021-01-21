project 'xcprotobuf.xcodeproj'

platform :ios, '14.0'

target 'xcprotobuf' do
  use_frameworks!

  pod 'Protobuf-C++', '~> 3.14'
end

post_install do |installer|
  for f in Dir.glob("Pods/Target Support Files/Protobuf-C++/**") do
    text = File.read(f) 
    content = text.gsub(/<UIKit\/UIKit.h>/, "<Foundation/Foundation.h>")
    File.open(f, "w") { |file| file << content }
  end
  # puts(%x[find . -name 'Pods/Target Support Files/Protobuf-C++/**'])
  puts(ENV['MACH_O_TYPE'])
  # %x[ #{for i in "Pods/Target Support Files/Protobuf-C++/"**; do sed -i '.bak' 's/<UIKit\\/UIKit.h>/<Foundation\\/Foundation.h>/g' $i; done }]

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'YES'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['HEADER_SEARCH_PATHS'] = 'Protobuf-C++/src'
      config.build_settings['MACH_O_TYPE'] = ENV['MACH_O_TYPE'] || 'mh_dylib' # 'staticlib'  #'mh_dylib'
      # prefix_header_file
    end
  end
end
