//
//  WindowGather.swift
//  Activity Logger
//
//  Created by HIDENORI MATSUKI on 2019/08/10.
//  Copyright © 2019 Hidenori Matsuki. All rights reserved.
//

import AppKit

struct WindowListGather {
    private static func generateWindowList() -> NSArray {
        let windowList: NSArray = CGWindowListCopyWindowInfo(.optionAll, 0) ?? []
        return windowList
    }
    
    private static func convertToWindowWindowInformationList(windowList: NSArray) -> [WindowInformation] {
        var result = Array<WindowInformation>()
        for dicOrAny in windowList {
            let raw = dicOrAny as! NSDictionary
            let info = WindowInformation(raw)
            if !info.isEmpty {
                result.append(info)
            }
        }
        return result
    }
    
    static func gather(_ persistenceStore: PersistenceStore) {
        let rawList = generateWindowList()
        let list = convertToWindowWindowInformationList(windowList: rawList)
        persistenceStore.save(list)
    }
}
