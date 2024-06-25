//
//  LayoutConstants.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 24/06/24.
//

import Foundation

enum SpacingConstants {
    case xsmall, small, medium, xmedium, large, xlarge, xxlarge
    
    var constant: CGFloat {
        switch self {
        case .xsmall: return 4
        case .small: return 8
        case .medium: return 16
        case .xmedium: return 20
        case .large: return 24
        case .xlarge: return 32
        case .xxlarge: return 40
        }
    }
}

enum ButtonSizeConstants {
    case large, appleSignIn
    
    var constant: CGFloat {
        switch self {
        case .large: return 46
        case .appleSignIn: return 48
        }
    }
}

enum RadiusConstants {
    case small
    
    var constant: CGFloat {
        switch self {
        case .small: return 8
        }
    }
}
