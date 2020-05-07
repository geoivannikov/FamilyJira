# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FamilyJira' do
  use_modular_headers!

  pod 'RealmSwift'
  pod 'Swinject'
  pod 'SnapKit'
  pod 'Toast-Swift'
  pod 'BTNavigationDropdownMenu'
  pod 'SwiftLint'
  pod 'CombineDataSources'
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/Database'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'


  target 'FamilyJiraTests' do
  end

end

target 'TodayTasks' do
    pod 'SnapKit'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if target.name.start_with? "Pods-TodayTasks"
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'AF_APP_EXTENSIONS=1']
            end
        end
    end
end
