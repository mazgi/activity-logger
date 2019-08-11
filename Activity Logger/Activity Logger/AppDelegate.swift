//
//  AppDelegate.swift
//  Activity Logger
//
//  Created by HIDENORI MATSUKI on 2019/08/11.
//  Copyright © 2019 HIDENORI MATSUKI. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Build status bar
        statusItem.button?.title = "Log"
        statusItem.menu = statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func startActivityLoggingMenuSelected(_ sender: NSMenuItem) {
        #if DEBUG
        NSLog("\(sender.title) selected")
        #endif
    }
    
    @IBAction func stopActivityLoggingMenuSelected(_ sender: NSMenuItem) {
        #if DEBUG
        NSLog("\(sender.title) selected")
        #endif
    }
    
    @IBAction func openLogDirectoryMenuSelected(_ sender: NSMenuItem) {
        #if DEBUG
        NSLog("\(sender.title) selected")
        #endif
    }
}
