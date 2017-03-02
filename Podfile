# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def rxswift
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt'
  pod 'NSObject+Rx'
end

target 'RxErrorHandling' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  rxswift

  target 'RxErrorHandlingTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
