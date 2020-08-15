import UIKit

public class BleScanPlugin: NSObject,MinewBeaconManagerDelegate{

    var bleManager:MinewBeaconManager? =  MinewBeaconManager.sharedInstance();
    
    
    public func minewBeaconManager(_ manager: MinewBeaconManager!, didRangeBeacons beacons: [MinewBeacon]!) {
        
        
        
    }
    
    public func minewBeaconManager(_ manager: MinewBeaconManager!, appear beacons: [MinewBeacon]!) {
        
    }
 
}
//import Flutter
//import UIKit
//
//public class SwiftBleScanPlugin: NSObject, FlutterPlugin,FlutterStreamHandler{
//
//    var eventSink:FlutterEventSink?=nil
//    public static func register(with registrar: FlutterPluginRegistrar) {
//        let channel = FlutterMethodChannel(name: "ble_scan", binaryMessenger: registrar.messenger())
//        let eventChannel=FlutterEventChannel(name:"ble_scan_event",binaryMessenger: registrar.messenger())
//        let instance = SwiftBleScanPlugin()
//        registrar.addMethodCallDelegate(instance, channel: channel)
//        eventChannel.setStreamHandler(instance)
//    }
//
//    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//        eventSink=events
//        return nil
//    }
//    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//
//        return nil
//    }
//    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        switch call.method {
//        case "init":
//
//            result(true)
//            break;
//        case "checkBleState":
//
//            break;
//        case "startBleScan":
//
//            result(true)
//            break;
//        case "stopBleScan":
//
//            result(true)
//            break;
//        case "setListener":
//            result(true)
//            break;
//        case "rmListener":
//            result(true)
//            break;
//        default:
//            result(FlutterMethodNotImplemented)
//        }
//
//    }
//
//
//}
