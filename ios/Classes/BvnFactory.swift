//
//  BvnFactory.swift
//  bvn_selfie
//
//  Created by Confidence Wangoho on 20/06/2023.
//

import Foundation
import Flutter

class BvnFactory:NSObject,FlutterPlatformViewFactory{
    private var messenger:FlutterBinaryMessenger
    
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init();
    }
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BvnView(messenger: messenger, frame: frame, viewId: viewId,arguments: args);
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
      }
}
