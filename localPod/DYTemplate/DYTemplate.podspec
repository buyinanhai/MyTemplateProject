

Pod::Spec.new do |spec|

  spec.name         = "DYTemplate"
  spec.version      = "1.0.0"
  spec.summary      = "ios开发的常用工具类"
  spec.description  = "个人iOS开发的积累，主要是开发常用的工具。"
  spec.homepage     = "https://github.com/buyinanhai/DYTemplate"
  spec.author       = { "buyinanhai" => "1026238004@qq.com" }
  spec.license      = { :type => "MIT", :file => "license" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/buyinanhai/DYTemplate.git", :tag => spec.version }
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

