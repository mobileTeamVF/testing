# Uncomment this line to define a global platform for your project
platform :ios, '13.0'


def shared_pods
    pod 'ObjectMapper', '~> 4.2.0'
    pod 'Alamofire', '~> 5.4.3'
    pod 'MBProgressHUD', '~> 1.2.0'
    pod 'SwiftyJSON', '~> 5.0.1'
    pod 'SVPullToRefresh', '~> 0.4.1'
    pod 'ReachabilitySwift', '~> 5.0.0'
#    pod 'CocoaLumberjack/Swift', '~> 3.7.2'
    pod 'TPKeyboardAvoiding', '~> 1.3.5'
#    pod 'ImageSlideshow', '~> 1.9.2'
    pod 'ImageSlideshow/Alamofire'
    pod 'PINRemoteImage', '~> 3.0.3'
    pod 'SKActivityIndicatorView', '~> 1.0.0'
    pod 'TransitionButton', '~> 0.5.2'
    pod 'RAMAnimatedTabBarController', '~> 5.0.1'
    pod 'ViewAnimator', '~> 2.5.1'
    pod 'BubbleTransition', '~> 3.2.0'
    pod 'FCAlertView', '~> 1.4.0'
    pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'
    pod 'NotificationBannerSwift', '~> 2.2.2'
#    pod 'DropDown', '~> 2.3.13'
    pod 'FlexiblePageControl', '~> 1.0.8'
    pod 'ImageScrollView', '~> 1.8.0'
    pod 'SkyFloatingLabelTextField', '~> 3.8.0'
    
    pod 'IQKeyboardManagerSwift', '~> 6.3.0'
    pod 'MGSwipeTableCell', '~> 1.6.11'
    pod 'GoogleMaps', '~> 5.1.0'
    pod 'Firebase/Crashlytics', '~> 8.3.0'
    pod 'Firebase/Analytics', '~> 8.3.0'
    pod 'OTPFieldView', '~> 1.0.1'
    pod 'Firebase/Messaging', '~> 8.3.0'
    
end

target 'TCLiOS' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    shared_pods
end


target 'TCLiOSTests' do
   inherit! :search_paths
   # Pods for testing
end

target 'TCLiOSUITests' do
   inherit! :search_paths
   # Pods for testing
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end
