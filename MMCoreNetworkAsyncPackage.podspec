Pod::Spec.new do |spec|
  
    spec.name         = "MMCoreNetworkAsyncPackage"
    spec.version      = "0.0.1"
    spec.summary      = "A short description"
  
    spec.homepage     = "https://github.com/MosMetro-official/MMCoreNetworkAsyncPackage"
  
    spec.license      = "MIT"
  
    spec.author       = { "Андрей Русинович" => "andreyrusinovich@icloud.com" }
  
    spec.platform     = :ios
    spec.platform     = :ios, "13.0"
  
    spec.ios.deployment_target = "13.0"
  
    spec.source       = { :git => "https://github.com/MosMetro-official/MMCoreNetworkAsyncPackage.git" }
  
    spec.source_files  = "Sources/MMCoreNetworkAsyncPackage/**/*.{swift}"
    
  end
