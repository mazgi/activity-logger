//
//  WindowImageCapture.swift
//  Activity Logger
//
//  Created by HIDENORI MATSUKI on 2019/08/10.
//  Copyright © 2019 Hidenori Matsuki. All rights reserved.
//

import AppKit

struct WindowImageCapture {
    static func captureImage(_ windowInformation: WindowInformation) -> NSImage? {
        if let cgImage = CGWindowListCreateImage(
            CGRect.null,
            CGWindowListOption.optionIncludingWindow,
            CGWindowID(windowInformation.windowNumber),
            CGWindowImageOption.nominalResolution),
            cgImage.width > 1 && cgImage.height > 1 {
            let size: CGSize = CGSize(width: windowInformation.bounds.width, height: windowInformation.bounds.height)
            let resultImage = NSImage(cgImage: cgImage, size: size)
            #if DEBUG
//            NSLog("""
//                image created.
//                windowInformation: \(windowInformation)
//                CGImage: \(cgImage)
//                NSImage: \(resultImage)
//                """)
            #endif
            return resultImage
        } else {
            return nil
        }
    }
}
