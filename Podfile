# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'LoginFirebaseTestApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LoginFirebaseTestApp
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'PKHUD', '~> 5.0'

  target 'LoginFirebaseTestAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LoginFirebaseTestAppUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end

end
