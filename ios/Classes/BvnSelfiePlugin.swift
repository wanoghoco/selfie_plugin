import Flutter
import UIKit

public class BvnSelfiePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
      
        let factory = BvnFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "bvnview_cam")
    }
   
}
