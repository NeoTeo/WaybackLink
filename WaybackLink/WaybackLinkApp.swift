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
    
    @MainActor
    class AppDelegate: NSObject, NSApplicationDelegate {
//        var popover = NSPopover.init()
        var pasteBoardCheckTimer: Timer?
        let wbLinkFetcher = WaybackLinkFetcher()
        
        var statusBarItem: NSStatusItem?
        
        private let pasteboard = NSPasteboard.general
        private var urlStrings = [String]()
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            
//            let contentView = ContentView()

            // Set the SwiftUI's ContentView to the Popover's ContentViewController
//            popover.behavior = .transient
//            popover.animates = false
//            popover.contentViewController = NSViewController()
//            popover.contentViewController?.view = NSHostingView(rootView: contentView)
//            popover.contentViewController?.view.window?.makeKey()
            
            statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem?.button?.image = NSImage(systemSymbolName: "circle", accessibilityDescription: "icon for WaybackLink app")
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
            
            guard let bestType = pasteboard.availableType(from: [ .URL, .string]) else {
                print("no requested type found")
                return
            }
                        
            for element in pasteboard.pasteboardItems! {
                
                guard let str = element.string(forType: bestType),
                        str.starts(with: "http"),
                      str.contains("archive.org") == false else { continue }
                
                /// might be more efficient to use the new Swift Collections library's ordered set
                guard urlStrings.contains(str) == false else { continue }
                
                urlStrings.append(str)
                
            }
            let name = urlStrings.count == 0 ? "circle" : "link.circle"
            statusBarItem?.button?.image = NSImage(systemSymbolName: name, accessibilityDescription: "icon for WaybackLink app")
        }
        
        @objc func togglePopover(_ sender: AnyObject?) {
            
            /// Clear pasteboard in preparation for replacing contents with Wayback link equivalents
            pasteboard.clearContents()
            
            // This might be a case for using a group task.
            for urlString in urlStrings {
                async {
                    if let wbLink = try? await wbLinkFetcher.linkFor(urlString: urlString) {
                        pasteboard.setString(wbLink, forType: .string)
                    }
                }
            }
            statusBarItem?.button?.image = NSImage(systemSymbolName: "link.circle.fill", accessibilityDescription: "icon for WaybackLink app")
            /// clear the urlStrings now that we're done
            urlStrings.removeAll()

        }
    }
}
