require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RnSpmDynamicPoc"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/mfazekas/rn-spm-dynamic-poc.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift,cpp}"
  s.private_header_files = "ios/**/*.h"

  install_modules_dependencies(s)

  # Source package: AlamofireDynamic is `type: .dynamic` in Alamofire's Package.swift, so Xcode builds
  # it into the shared $PODS_CONFIGURATION_BUILD_DIR/PackageFrameworks/AlamofireDynamic.framework.
  spm_dependency(s,
    url: "https://github.com/Alamofire/Alamofire.git",
    requirement: { kind: "upToNextMajorVersion", minimumVersion: "5.9.1" },
    products: ["AlamofireDynamic"]
  )

  # Binary package: RiveRuntime is a prebuilt dynamic xcframework, which Xcode places at
  # <pod build dir>/RiveRuntime.framework.
  spm_dependency(s,
    url: "https://github.com/rive-app/rive-ios.git",
    requirement: { kind: "exactVersion", version: "6.26.0" },
    products: ["RiveRuntime"]
  )
end
