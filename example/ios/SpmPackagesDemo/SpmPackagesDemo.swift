import AgoraRtcKit
import FirebaseAnalytics
import MapboxMaps
import StripePaymentSheet

@objc(SpmPackagesDemo)
public class SpmPackagesDemo: NSObject {
  @objc
  public static func describe() -> String {
    [
      "Agora \(AgoraRtcEngineKit.getSdkVersion())",
      String(describing: MapView.self),
      String(describing: PaymentSheet.self),
      String(describing: Analytics.self),
    ].joined(separator: "\n")
  }
}
