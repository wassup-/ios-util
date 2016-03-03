#
# Be sure to run `pod lib lint ios-util.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    # info
    s.name             = 'ios-util'
    s.version          = '0.1.7'
    s.summary          = 'Utility library for iOS development.'

    s.description      = 'This utility library contains classes (controllers, views, categories, ...) which may help/speedup iOS application development.'

    s.homepage         = 'https://github.com/wassup-/ios-util'
    s.author           = {
        'Tom Knapen' => 'tom@knapen.io'
    }
    s.license          = {
        :type => 'MIT',
        :file => 'LICENSE.md'
    }

    # configuration
    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.source           = {
        :git => 'https://github.com/wassup-/ios-util.git',
        :tag => s.version.to_s
    }
    s.source_files = 'Pod/Classes/**/*'
    s.resource_bundles = {
        'ios-util' => ['Pod/Assets/*.png']
    }

    # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'CoreGraphics', 'Foundation', 'UIKit'
    s.dependency 'MagicalRecord'
    s.dependency 'Masonry'
end
