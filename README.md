# What is this?

A POC of embedding the dynamic frameworks of Swift Package Manager dependencies declared with react-native's [`spm_dependency`](https://github.com/facebook/react-native/pull/44627)

Without it the app builds, but crashes at launch:
```
dyld: Library not loaded: @rpath/RiveRuntime.framework/RiveRuntime
```
and archives fail on Xcode 26:
```
"RiveRuntime.xcframework-ios.signature" couldn't be copied to "Signatures" because an item with the same name already exists.
```

How to run:
```
yarn install
cd example/ios
pod install

# Make sure you close and reopen workspace
```

# How it works:

1. The library `.podspec` defines two Swift Package Manager dependencies: a source package building a dynamic framework (`AlamofireDynamic`) and a binary target (`RiveRuntime`):

https://github.com/mfazekas/rn-spm-dynamic-poc/blob/3a9cd65da2f3f2fc1203538019470a0dd09d6d59/RnSpmDynamicPoc.podspec#L21-L35

2. There is a react-native [patchfile](https://github.com/mfazekas/rn-spm-dynamic-poc/blob/main/example/patches/react-native%2B0.84.0.patch) that:
   - adds an `install_spm_frameworks` call to the app's `[CP] Embed Pods Frameworks` script for every pod with SPM dependencies. At build time it embeds the dynamic frameworks of the pod's binary targets (`$PODS_CONFIGURATION_BUILD_DIR/<pod>/`) and of its source package products (`$PODS_CONFIGURATION_BUILD_DIR/PackageFrameworks/`, or `$OBJROOT/UninstalledProducts/<platform>/` when archiving), and skips static ones
   - adds a build phase to the pod removing its copy of `*.xcframework-*.signature`. Xcode processes a binary target's xcframework for both the pod and the app, and Xcode 26 archives fail on the duplicate

   https://github.com/mfazekas/rn-spm-dynamic-poc/blob/803db8fee90bcb578f0b96535c422923ff25b739/example/patches/react-native%2B0.84.0.patch#L44-L118

To see the crash, remove `example/patches` and reinstall `react-native`.

| Xcode 26.5, RN 0.84.0 | stock | patched |
| --- | --- | --- |
| Debug simulator launch | dyld crash (`RiveRuntime`) | launches |
| Release archive | fails (duplicate signature) | succeeds, both frameworks embedded |

# Limitations/known issues:

- XCode workspace should be closed/reopened for XCode to realize that the package dependency was readded
- Debug simulator builds hide a missing source package framework: Xcode adds an rpath into the build directory, so it loads from the Mac's disk. Devices, Release builds and binary targets crash.
- When pod install invoked with `USE_FRAMEWORKS=none` (static libraries), source package products such as `AlamofireDynamic` are not linked into the app, and linking fails with undefined symbols
- The embed phase does not declare the package frameworks as inputs. The requirements are written into the embed script, so changing them in the podspec re-runs it after `pod install`, but a version resolved differently without `pod install` needs a clean build

# See also

https://github.com/facebook/react-native/pull/44627

https://github.com/react-native-community/discussions-and-proposals/issues/587

https://github.com/mfazekas/rn-spm-rfc-poc

https://github.com/rive-app/rive-nitro-react-native/pull/400 - the same fix done from a library podspec, until react-native does it



# rn-spm-dynamic-poc

Demo: SPM dynamic framework (AlamofireDynamic) embedding issue with spm_dependency

## Installation


```sh
npm install rn-spm-dynamic-poc
```


## Usage


```js
import { multiply } from 'rn-spm-dynamic-poc';

// ...

const result = multiply(3, 7);
```


## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
