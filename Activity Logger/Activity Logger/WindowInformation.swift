//
//  WindowInformation.swift
//  Activity Logger
//
//  Created by HIDENORI MATSUKI on 2019/08/10.
//  Copyright © 2019 Hidenori Matsuki. All rights reserved.
//

import Foundation
import CoreGraphics

struct WindowInformation {
    let json: Data
    let name: String
    let ownerName: String
    let alpha: Float
    let bounds: CGRect
    let isOnscreen: Bool
    let windowNumber: Int

    var isEmpty: Bool {
        guard
            !json.isEmpty,
            !name.isEmpty,
            name != "Notification Center",
            name != "Item-0",
            name != "Focus Proxy",
            name != "Spotlight",
            name != "Desktop",
            !name.contains("Desktop Picture"),
            ownerName != "Notification Center",
            ownerName != "Dock",
            ownerName != "Window Server",
            ownerName != "SystemUIServer",
            alpha > 0,
            !bounds.isEmpty,
//            isOnscreen,
            windowNumber >= 0
        else {
            #if DEBUG
//            NSLog("isEmpty: \(json)")
            #endif
            return true
        }
        return false
    }

    init() {
        json = Data()
        name = ""
        ownerName = ""
        alpha = .zero
        bounds = .zero
        isOnscreen = false
        windowNumber = .zero
    }
    
    init(_ from: NSDictionary, config: WindowInformationConfig = WindowInformationConfig()) {
        #if DEBUG
//        NSLog("a dictionary received: \(from)")
        #endif
        
        do {
            json = try JSONSerialization.data(withJSONObject: from, options: [])
        } catch {
            json = Data()
        }
        
        name = from[kCGWindowName] as? String ?? ""
        ownerName = from[kCGWindowOwnerName] as? String ?? ""
        alpha = from[kCGWindowAlpha] as? Float ?? 0
        if let boundsDic = from[kCGWindowBounds] as? NSDictionary,
            let rect = CGRect(dictionaryRepresentation: boundsDic) {
            bounds = rect
        } else {
            bounds = .zero
        }
        isOnscreen = from[kCGWindowIsOnscreen] as? Bool ?? false
        windowNumber = from[kCGWindowNumber] as? Int ?? -1
    }
}

extension WindowInformation {
    var tableHeadRow: [String] {
        return [
            "name",
            "ownerName",
            "windowNumber",
        ]
    }
    
    var tableRow: [String] {
        return [
            name,
            ownerName,
            String(windowNumber),
        ]
    }
}
