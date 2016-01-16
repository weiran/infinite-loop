workspace 'Circles.xcworkspace'
platform :ios, '9.0'

use_frameworks!

# ignore warmings from pods
inhibit_all_warnings!

def shared_pods
	pod 'GCHelper'
end

xcodeproj 'Circles.xcodeproj'
xcodeproj 'Circles iOS.xcodeproj'

# no tvOS support for cocoapods yet
# target :Circles do
# 	shared_pods
# end

target 'Circles iOS' do
	shared_pods
end