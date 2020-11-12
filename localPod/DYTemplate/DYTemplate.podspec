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

  spec.name         = "DYTemplate"
  spec.version      = "1.0.0"
  spec.summary      = "我的工程模板"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = "个人iOS开发的积累，主要是开发常用的工具。"

  spec.homepage     = "https://dongyee.edu"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = "Dongye"
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
 
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/buyinanhai/DYTemplate.git", :tag => "v#{spec.version}" }
  

  spec.source_files  = ["Classes",
     "Classes/*.{h,m,swift}",
     "Classes/Macros/*.{h,swift}"]
  spec.exclude_files = "Classes/Exclude"
  

  spec.public_header_files = "DYTemplate.h"

  spec.requires_arc = true
  spec.static_framework = true
  spec.swift_version = '5.0'

  #全局引用文件
  spec.prefix_header_contents = <<-DESC
  #import "DYOCHeader.h"
  #import "DYMacro.h"
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
  
  spec.dependency "Masonry"
  spec.dependency "AFNetworking"
  spec.dependency "MJRefresh"
  spec.dependency "ObjectMapper"
  spec.dependency "SDWebImage"
  
  #spec.dependency "AlipaySDK-iOS"
  
  spec.pod_target_xcconfig = {
     "GCC_PREPROCESSOR_DEFINITIONS" => "$(inherited) DYTemplate_NAME=#{spec.name} DYTemplate_VERSION=#{spec.version}",
   }
  
  spec.default_subspecs = ["Base", "ComponentUI", "Network", "Tool"]

  spec.subspec "Tool" do | base_spec |
    
    base_spec.source_files = ["Classes/Tool/*.{h,m}"]
    base_spec.public_header_files = ["Classes/Tool/*.h"]
    
  end
  
  spec.subspec "Base" do | base_spec |
    
    base_spec.source_files = ["Classes/Category/*.{h,m}",
    "Foundation/**/*.{h,m}", "UIKit/**/*.{h,m}"]
    base_spec.public_header_files = ["Classes/Category/*.h","Foundation/**/*.h", "UIKit/**/*.h",]
    
    
  end
  
  spec.subspec "ComponentUI" do | component_spec |
    
    component_spec.source_files = ["Classes/Components/*.{h,m,swift}","Classes/Components/**/*.{h,m,swift}"]
    component_spec.public_header_files = ["Classes/Components/*.h","Classes/Components/**/*.h"]
    
  end
  
  spec.subspec "Network" do | network_spec |
    
    network_spec.source_files = ["Classes/Network/*.{h,m}","Classes/Network/DYNetwork/*.{h,m}","Classes/Network/DYNetwork/YTK/*.{h,m}"]
    network_spec.public_header_files = ["Classes/Network/DYBaseNetwork.h"]
    
  end
  
  
end

