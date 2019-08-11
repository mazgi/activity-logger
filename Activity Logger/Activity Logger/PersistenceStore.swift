//
//  PersistenceStore.swift
//  Activity Logger
//
//  Created by HIDENORI MATSUKI on 2019/08/10.
//  Copyright © 2019 Hidenori Matsuki. All rights reserved.
//

import AppKit

protocol PersistenceStoreDelegate: AnyObject {
    func save(_ list: [WindowInformation])
}

extension PersistenceStore {
    enum StoreType {
        case local
    }
    
    static func getPersistenceStore(
        _ saveDestination: URL,
        storeType: StoreType = .local) -> PersistenceStore {
        return LocalPersistenceStore(saveDestination)
    }
}

class PersistenceStore: PersistenceStoreDelegate {
    let datetimeFormat = "yyyyMMdd-HHmm"
    let saveDestination: URL
    
    internal init(_ saveDestination: URL) {
        self.saveDestination = saveDestination
        #if DEBUG
        NSLog("save files to: \(self.saveDestination)")
        #endif
    }
    
    internal func saveImage(_ image: NSImage, fileBasename: String, saveTo: URL) {
        #if DEBUG
//        NSLog("image received: \(image)")
        #endif
    }
    
    internal func saveList(_ list: [WindowInformation], saveTo: URL) {
        #if DEBUG
//        NSLog("list received: \(list)")
        #endif
    }
    
    func save(_ list: [WindowInformation]) {
        let fmt = DateFormatter()
        fmt.dateFormat = datetimeFormat
        let datetimePrefix = fmt.string(from: Date())
        let saveDestinationWithPrefix = self.saveDestination.appendingPathComponent(datetimePrefix)
        let _ = list.map { (info) in
            #if DEBUG
//            NSLog("windowInformation: \(info)")
            #endif
            let imageFilename = "window_\(info.windowNumber)"
            if !info.isEmpty {
                if let image = WindowImageCapture.captureImage(info) {
                    saveImage(image, fileBasename: imageFilename, saveTo: saveDestinationWithPrefix)
                }
            }
        }
        saveList(list, saveTo: saveDestinationWithPrefix)
    }
}

class LocalPersistenceStore: PersistenceStore {
    private func createDirectory(saveDestination: URL) {
        do {
            try FileManager.default.createDirectory(at: saveDestination, withIntermediateDirectories: true, attributes: nil)
        } catch {
            NSLog("""
                Unexpected error, cannot create directory: \(error).
                destination: \(saveDestination)
                """)
        }
    }
    
    internal override func saveImage(_ image: NSImage, fileBasename: String, saveTo: URL) {
        super.saveImage(image, fileBasename: fileBasename, saveTo: saveTo)
        createDirectory(saveDestination: saveTo)
        let saveDestination = saveTo.appendingPathComponent("\(fileBasename).png")
        if let imageData = image.tiffRepresentation,
            let imageRep = NSBitmapImageRep(data: imageData),
            let pngData = imageRep.representation(
                using: NSBitmapImageRep.FileType.png,
                properties: [:]) {
            do {
                try pngData.write(to: saveDestination, options: Data.WritingOptions.atomicWrite)
            } catch {
                NSLog("""
                    Unexpected error, cannot save the image: \(error).
                    destination: \(saveDestination)
                    image: \(image)
                    """)
            }
        }
    }
    
    override func saveList(_ list: [WindowInformation], saveTo: URL) {
        super.saveList(list, saveTo: saveTo)
        createDirectory(saveDestination: saveTo)
        var csvRows = Array<String>()
        let head = WindowInformation().tableHeadRow
        csvRows.append(head.joined(separator: ","))
        let _ = list.map { (info) in
            let row = info.tableRow
            csvRows.append(row.joined(separator: ","))
        }
        
        let csvText = csvRows.joined(separator: "\n")
        let saveDestination = saveTo.appendingPathComponent("index.csv")
        do {
            try csvText.write(to: saveDestination, atomically: true, encoding: .utf8)
        } catch {
            NSLog("""
                Unexpected error, cannot save the list: \(error).
                destination: \(saveDestination)
                """)
        }
    }
}
