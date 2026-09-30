// The Sentry-Dynamic product is a binary target whose framework is Sentry.framework, so the podspec
// names it in `embed_frameworks`.
import Sentry

@objc(UseSentry)
public class UseSentry: NSObject {
  @objc
  public func getVersion() -> String {
    let info = Bundle(for: SentrySDK.self).infoDictionary
    let version = info?["CFBundleShortVersionString"] as? String ?? "unknown"
    return "Sentry \(version) ✓"
  }
}
