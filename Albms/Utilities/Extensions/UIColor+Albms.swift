//
//  UIColor+Albms.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit

extension UIColor {
    
    // 12 12 12
    static func albDarkBackground() -> UIColor {
        return UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
    }
    
    // 242 242 242
    static func albLightForeground() -> UIColor {
        return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    }
    
    // 42 42 42
    static func albDarkGray() -> UIColor {
        return UIColor(red: 0.164, green: 0.164, blue: 0.164, alpha: 1.0)
    }
    
    // 153 153 153
    static func albMediumGray() -> UIColor {
        return UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    }
    
    // 216 216 216
    static func albLightGray() -> UIColor {
        return UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1.0)
    }
    
    // 144 203 64
    static func albMediumGreen() -> UIColor {
        return UIColor(red: 0.564, green: 0.79, blue: 0.25, alpha: 1.0)
    }
    
    // 55 220 2
    static func albFloGreen() -> UIColor {
        return UIColor(red: 0.215, green: 0.862, blue: 0.007, alpha: 1.0)
    }
}
