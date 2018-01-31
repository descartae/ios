platform :ios, '10.3'
inhibit_all_warnings!

target 'Descartae' do
  use_frameworks!

  # Network
  pod 'SDWebImage', '~> 4'
  pod 'Apollo', '~> 0.7.0'
  pod 'ReachabilitySwift'

  # Geolocation
  pod 'CMMapLauncher', '~> 1.1.0'

  # UI
  pod 'BBBadgeBarButtonItem'
  pod 'SVProgressHUD'
  pod 'RazzleDazzle'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'

  # Facebook
  pod 'FBSDKCoreKit', '~> 4.29.0'
  pod 'FBSDKLoginKit', '~> 4.29.0'
  pod 'FBSDKShareKit', '~> 4.29.0'
  
  target 'DescartaeTests' do
    inherit! :search_paths
  end

  target 'DescartaeUITests' do
    inherit! :search_paths
  end

end
