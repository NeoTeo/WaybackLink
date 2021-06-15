//
//  WaybackLinkApp.swift
//  WaybackLink
//
//  Created by teo on 15/06/2021.
//

import SwiftUI

@main
struct WaybackLinkApp: App {
    
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {

        Settings {
            EmptyView()
        }
    }
    
    class AppDelegate: NSObject, NSApplicationDelegate {
//        var popover = NSPopover.init()
        var pasteBoardCheckTimer: Timer?
        let wbLinkFetcher = WaybackLinkFetcher()
        
        var statusBarItem: NSStatusItem?
        var test: Bool = false
        var statusSymbol: NSImage? = NSImage(systemSymbolName: "circle", accessibilityDescription: "icon for WaybackLink app")
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            
            let contentView = ContentView()

            // Set the SwiftUI's ContentView to the Popover's ContentViewController
//            popover.behavior = .transient
//            popover.animates = false
//            popover.contentViewController = NSViewController()
//            popover.contentViewController?.view = NSHostingView(rootView: contentView)
//            popover.contentViewController?.view.window?.makeKey()
            
            statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem?.button?.image = statusSymbol
//            statusBarItem?.button?.title = "WaybackLink"
            statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
            
            if pasteBoardCheckTimer == nil {
                pasteBoardCheckTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                    self.updateStatus()
                }
            }
        }
        
//        @objc func showPopover(_ sender: AnyObject?) {
//            if let button = statusBarItem?.button {
//                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
//    //            !!! - displays the popover window with an offset in x in macOS BigSur.
//            }
//        }
//        @objc func closePopover(_ sender: AnyObject?) {
//            popover.performClose(sender)
//        }
        func updateStatus() {
//            if NSPasteboard
            print("pasteboard status checked.")
        }
        
        @objc func togglePopover(_ sender: AnyObject?) {
            print("toggle! \(test)")
            let name = (test == true) ? "link.circle.fill" : "link.circle"
            statusBarItem?.button?.image = NSImage(systemSymbolName: name, accessibilityDescription: "icon for WaybackLink app")
            async {
                guard let wbLink = try? await wbLinkFetcher.linkFor(urlString: "some url") else { return }
                print("Got back a link: \(wbLink)")
            }
            test.toggle()
        }
//            if popover.isShown {
//                closePopover(sender)
//            } else {
//                showPopover(sender)
//            }
//        }
    }
}
