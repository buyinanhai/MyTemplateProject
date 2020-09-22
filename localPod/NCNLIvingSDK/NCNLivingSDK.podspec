#
#  Be sure to run `pod spec lint NCNLivingSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "NCNLivingSDK"
  spec.version      = "0.0.1"
  spec.summary      = "新云网直播上课sdk 包含UI"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = "新云网内部直播上课工具 使用说明： 1.将LocalPod文件夹放到工具根目录(手动集成)  2.依赖库 有 libc++ libiconv libbz2 libz AudioToolbox VideoToolbox"

  spec.homepage     = "https://xinyunwang.edu"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = "License"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "汪宁" => "汪宁" }
  # Or just: spec.author    = ""
  # spec.authors            = { "" => "" }
  # spec.social_media_url   = "https://twitter.com/"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
   spec.platform     = :ios, "9.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :svn => "https://192.168.19.201/svn/%E6%A0%B8%E5%BF%83%E5%9F%BA%E7%A1%80%E5%BA%93/%E7%A0%94%E5%8F%91/iOS/%E7%9B%B4%E6%92%ADiOS/%E4%BB%A3%E7%A0%81/NCNLivingSDK" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp file
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "Classes",
     "Classes/*.{h,m}",
     "Classes/**/*.{h,m,mm}",
     "Classes/**/**/*.{h,m,mm}",
     "Classes/**/**/**/*.{h,m,mm}",
     "Classes/**/**/**/**/*.{h,m,mm}",
     "Classes/**/**/**/**/**/*.{h,m,mm}",
     "Classes/**/**/**/**/**/**/*.{h,m,mm}"
  spec.exclude_files = "Classes/Exclude"

  spec.public_header_files = "NCNLivingSDK.h"

  spec.requires_arc = true
  spec.static_framework = true
  
  spec.vendored_frameworks = ['*.framework']

  #全局引用文件
  spec.prefix_header_contents = <<-DESC
  #import "NCLiveSDKHeader.h"
  DESC
  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

   spec.resources  = "Resources/*.bundle",
            "Classes/**/*.xib",
            "Classes/**/**/*.xib",
            "Classes/**/**/**/*.xib",
            "Classes/**/**/**/**/*.xib",
            "Classes/**/**/**/**/**/*.xib",
            "Classes/**/**/**/**/**/**/*.xib"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"

  # spec.library   = "iconv"
#  spec.libraries = "iconv", "z", "sqlite3", "xml2.2"

  spec.frameworks = "AudioToolbox", "VideoToolbox", "Accelerate"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  spec.pod_target_xcconfig = { "ENABLE_BITCODE" => "NO"}
  spec.user_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
#   spec.dependency "LFLiveKit"
   spec.dependency "Masonry"
   spec.dependency "AFNetworking"
   spec.dependency "Socket.IO-Client-Swift"
   spec.dependency "TZImagePickerController"
   spec.dependency "TXLiteAVSDK_TRTC"
   spec.dependency "MBProgressHUD"
   
   spec.dependency "SDWebImage"
  
   spec.dependency "DYTemplate/ComponentUI"
   

   #为了引用IJKMedia库 而引用这个本地库s
#   spec.dependency 'LibMediaSDK/CCLiveSDK'

end

