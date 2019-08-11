//
//  WindowInformationRaw.swift
//  Activity Logger
//
//  Created by HIDENORI MATSUKI on 2019/08/10.
//  Copyright © 2019 Hidenori Matsuki. All rights reserved.
//

import Foundation

struct WindowInformationRaw: Codable {
    var kCGWindowAlpha: Float
    var kCGWindowBounds: WindowBounds
    struct WindowBounds: Codable {
        var Height: Int
        var Width: Int
        var X: Int
        var Y: Int
    }
    var kCGWindowLayer: Int
    var kCGWindowMemoryUsage: Int
    var kCGWindowName: String?
    var kCGWindowNumber: Int
    var kCGWindowOwnerName: String
    var kCGWindowOwnerPID: Int
    var kCGWindowSharingState: Int
    var kCGWindowStoreType: Int
}
