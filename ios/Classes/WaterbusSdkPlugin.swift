import Flutter
import UIKit
import waterbus_callkit_incoming

public class WaterbusSdkPlugin: NSObject, FlutterPlugin {
  var uuidCall: String = ""

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
    case "startCallKit":
      let arguments = call.arguments as? [String: Any] ?? [String: Any]()
      let uuidCallPartner = NSUUID().uuidString
      self.uuidCall = uuidCallPartner

      let nameCall = arguments["nameCaller"] as? String ?? "Waterbus"
      var info = [String:Any?]()
      info["id"] = uuidCallPartner
      info["nameCaller"] = nameCall
      info["handle"] = "0123456789"
      info["type"] = 1
      
      SwiftFlutterCallkitIncomingPlugin.sharedInstance?.startCall(waterbus_callkit_incoming.Data(args: info), fromPushKit: true)
      result(true)
      break
    case "getCurrentUuid":
      result(self.uuidCall)
      break
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
