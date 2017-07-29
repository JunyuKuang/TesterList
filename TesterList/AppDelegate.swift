//
//  AppDelegate.swift
//  TesterList
//
//  Created by Jonny on 7/29/17.
//  Copyright © 2017 Jonny. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window = NSApp.windows.first
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window?.makeKeyAndOrderFront(self)
        return false
    }
}


