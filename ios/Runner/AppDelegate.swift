import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Inicializa Google Maps con tu clave de API
    GMSServices.provideAPIKey("AIzaSyAhRV-DPKdC2wKs0cxjVDXMZ2473bTmvIQ")

    // Registra los plugins de Flutter
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}