# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Caristocrat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire'#, ‘4.2.0’
  pod 'SwiftyJSON'#, '3.1.3'
  pod 'IQKeyboardManagerSwift'
#  pod 'EZAlertController'#, '3.2'
  pod 'TPKeyboardAvoiding'
  pod 'RealmSwift'
  pod "Device" #, '~> 2.0.1'
  pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'
  pod 'NVActivityIndicatorView'
  pod 'SwiftMessages'
  pod 'Kingfisher' #, '~> 3.2.4'
  pod 'DZNEmptyDataSet'
  pod 'Reachability'
  pod 'EAIntroView' #, '~> 2.10.0'
  pod 'UIAlertController+Blocks' #, '~> 0.9.2'
  pod 'RESideMenu'
  pod 'CountryPickerSwift' #, '~> 1.4.2'
#  pod 'KMPlaceholderTextView' #, '~> 1.3.0'
  pod "SkeletonView"
#  pod 'DGElasticPullToRefresh'
  pod 'TWMessageBarManager'
  pod 'MBProgressHUD'
  pod 'SVProgressHUD'
  pod 'PinCodeTextField'
  pod 'ImageSlideshow'
#  pod 'Bottomsheet'
  pod 'FaveButton'
  pod 'TableViewDragger'
  pod 'ImageSlideshow/Kingfisher'
  pod 'EasyTipView'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'CountdownLabel'
  pod 'GoogleSignIn', '< 5.0.0'
  pod 'FBSDKLoginKit'
  pod 'RangeSeekSlider'
  pod 'YouTubePlayer'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'BDKCollectionIndexView'
  pod 'SpreadsheetView'
  pod 'Cosmos'
  pod 'SwiftyStoreKit'
  pod 'SwiftDate'


 post_install do |installer|
       installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
               config.build_settings['SWIFT_VERSION'] = '4.2' # or '3.0'
           end
       end
   end


end
