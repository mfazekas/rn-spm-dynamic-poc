# Swift packages whose frameworks are not simply named after their product.
Pod::Spec.new do |s|
  s.name         = "SpmPackagesDemo"
  s.version      = "0.0.1"
  s.summary      = "spm_dependency packages with several, transitive, automatic and static frameworks"
  s.homepage     = "https://github.com/mfazekas/rn-spm-dynamic-poc"
  s.license      = "MIT"
  s.authors      = "Miklós Fazekas"
  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/mfazekas/rn-spm-dynamic-poc.git" }
  s.source_files = "*.swift"

  # One product, several binary frameworks, none named after the product.
  spm_dependency(s,
    url: "https://github.com/AgoraIO/AgoraRtcEngine_iOS.git",
    requirement: { kind: "exactVersion", version: "4.7.0" },
    products: ["RtcBasic"],
    # aosl comes from the AgoraInfra_iOS package that AgoraRtcEngine_iOS depends on.
    embed_frameworks: ["AgoraRtcKit", "Agorafdkaac", "Agoraffmpeg", "AgoraSoundTouch", "video_dec", "aosl"]
  )
  # Source product whose dynamic frameworks come from the packages it depends on.
  spm_dependency(s,
    url: "https://github.com/mapbox/mapbox-maps-ios.git",
    requirement: { kind: "exactVersion", version: "11.31.1" },
    products: ["MapboxMaps"],
    # Binary frameworks of the mapbox-common-ios, mapbox-core-maps-ios and turf-swift packages.
    embed_frameworks: ["MapboxCommon", "MapboxCoreMaps", "Turf"]
  )
  # Source products with automatic linkage.
  spm_dependency(s,
    url: "https://github.com/stripe/stripe-ios.git",
    requirement: { kind: "exactVersion", version: "26.12.1" },
    products: ["StripePaymentSheet"]
  )
  # Static binary frameworks.
  spm_dependency(s,
    url: "https://github.com/firebase/firebase-ios-sdk.git",
    requirement: { kind: "exactVersion", version: "12.19.2" },
    products: ["FirebaseAnalytics"]
  )
end
