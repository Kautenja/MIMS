platform :ios, “9.0”
use_frameworks!

target “MIMS” do
pod ‘MBProgressHUD’
pod ‘Parse’
pod ‘ParseUI’
pod ‘SmileTouchID’
pod ‘IQKeyboardManager’
pod ‘DZNEmptyDataSet’
pod 'SQLite.swift'
pod 'THCalendarDatePicker', '~> 1.2.6'

post_install do |installer|
  installer.pods_project.build_configuration_list.build_configurations.each do |configuration|

configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
  end
end

target "MIMSTests" do
pod 'Parse'
end

end
