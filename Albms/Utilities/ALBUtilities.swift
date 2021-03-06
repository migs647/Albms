//
//  ALBUtilities.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import Foundation

struct ALBUtility {
    
    static var dispatchQueue: DispatchQueue?
    
    static func notYetImplemented(message: String) {
        #if DEBUG
        
        print("Not Yet Implemented")
        
        // TODO: Show an alertview here
        #endif
    }
    
    static func executeOnMainQueue(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    static func executeOnMainQueueAndWait(_ block: @escaping () -> Void) {
        DispatchQueue.main.sync(execute: block)
    }
    
    static func executeInBackground(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async(execute: block)
    }
    
    static func executeInBackgroundAndWait(_ block: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).sync(execute: block)
    }
}
