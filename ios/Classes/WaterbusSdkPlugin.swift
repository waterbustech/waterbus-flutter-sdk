import Flutter
import UIKit

public class WaterbusSdkPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "waterbus-sdk/native-plugin", binaryMessenger: registrar.messenger())
    let instance = WaterbusSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("" + UIDevice.current.systemVersion)
      break
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
