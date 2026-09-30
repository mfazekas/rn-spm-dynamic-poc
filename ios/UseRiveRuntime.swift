// RiveRuntime is a binary target (prebuilt dynamic xcframework). Unlike source packages, Xcode adds
// no build-directory rpath for it, so a missing embed crashes on the simulator too.
import RiveRuntime

@objc(UseRiveRuntime)
public class UseRiveRuntime: NSObject {
  @objc
  public func getVersion() -> String {
    let info = Bundle(for: RiveFile.self).infoDictionary
    let version = info?["CFBundleShortVersionString"] as? String ?? "unknown"
    return "RiveRuntime \(version) ✓"
  }
}
