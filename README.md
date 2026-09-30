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

1. The library `.podspec` defines three Swift Package Manager dependencies: a source package building a dynamic framework (`AlamofireDynamic`), a binary target (`RiveRuntime`), and a binary target whose framework is named differently from its product (`Sentry-Dynamic` is `Sentry.framework`), which it declares with `embed_frameworks`:

https://github.com/mfazekas/rn-spm-dynamic-poc/blob/c40072cae5229ab4afaa98bfc70616926dfb630e/RnSpmDynamicPoc.podspec#L21-L44

2. There is a react-native [patchfile](https://github.com/mfazekas/rn-spm-dynamic-poc/blob/main/example/patches/react-native%2B0.84.0.patch) that:
   - adds an `embed_frameworks` parameter to `spm_dependency`: the dynamic frameworks the products bring, defaulting to the product names
   - adds an `install_spm_framework <name> <pod build dir>` line per framework to the app's `[CP] Embed Pods Frameworks` script. At build time it looks for the framework next to the pod (binary targets), then in `$PODS_CONFIGURATION_BUILD_DIR/PackageFrameworks/` (source packages) or `$OBJROOT/UninstalledProducts/<platform>/` (source packages when archiving), and embeds it unless it is missing or static
   - adds a build phase to the pod removing its copy of `*.xcframework-*.signature`. Xcode processes a binary target's xcframework for both the pod and the app, and Xcode 26 archives fail on the duplicate

   https://github.com/mfazekas/rn-spm-dynamic-poc/blob/72a1187369b98bead3f396b9ba8d63e1c2fcff7c/example/patches/react-native%2B0.84.0.patch

To see the crash, remove `example/patches` and reinstall `react-native`.

| Xcode 26.5, RN 0.84.0 | stock | patched |
| --- | --- | --- |
| Debug simulator launch | dyld crash (`RiveRuntime`) | launches |
| Release archive | fails (duplicate signature) | succeeds, all three frameworks embedded |
| Patched, without `embed_frameworks: ["Sentry"]` | | dyld crash (`Sentry`) |

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
