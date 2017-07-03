# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'SimpleCalendar' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for SimpleCalendar
  pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', branch: 'master', :submodules => true
  pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa.git', branch: 'master', :submodules => true
  pod 'SwiftyJSON'
end

target 'SimpleCalendarTests' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    # Pods for SimpleCalendar
    pod 'Realm', :git => 'https://github.com/realm/realm-cocoa.git', branch: 'master', :submodules => true
    pod 'RealmSwift', :git => 'https://github.com/realm/realm-cocoa.git', branch: 'master', :submodules => true
    pod 'SwiftyJSON'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0' # or '2.3'
        end
    end
end
