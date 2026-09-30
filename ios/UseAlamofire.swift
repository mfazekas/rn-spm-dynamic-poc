// Importing AlamofireDynamic here is the key:
// - If the framework IS embedded in the app bundle  → this loads fine
// - If the framework is NOT embedded                → dyld crashes at app launch
import Alamofire

@objc(UseAlamofire)
public class UseAlamofire: NSObject {
  @objc
  public func getVersion() -> String {
    // Reading from Alamofire's bundle proves it is actually loaded at runtime.
    let info = Bundle(for: Session.self).infoDictionary
    let version = info?["CFBundleShortVersionString"] as? String ?? "unknown"
    return "AlamofireDynamic \(version) ✓"
  }
}
