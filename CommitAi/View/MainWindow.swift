//
//  MainWindow.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/2.
//

import SwiftUI
import Cocoa

class MainWindowController: NSWindowController {
    
    private static var windowController: MainWindowController?
    
    static func show() {
        if windowController == nil {
            let window = NSWindow(contentViewController: MainVC())
            windowController = MainWindowController(window: window)
            windowController!.window?.title = "CommitAi"
            let frame = NSScreen.main!.getCenterFrame(with: CGSize(width: 650, height: 500))
            windowController!.window?.setFrame(frame, display: true)
            
            window.isOpaque = false
            window.appearance = .none
            window.backgroundColor = .windowBackgroundColor
            windowController!.showWindow(nil)
        } else {
            windowController!.showWindow(nil)
        }
        
    }
    
}

class MainVC: NSHostingController<MainView> {
    
    init() {
        super.init(rootView: MainView())
        rootView.vc = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: MainView())
        rootView.vc = self
    }
}

struct MainView: View {
    
    weak var vc: NSViewController!
    @State private var selectedItem: Item? = FolderList.shared.folders.first
    @StateObject private var folderList = FolderList.shared

    var body: some View {
        NavigationView {
            SidebarView(folderList: folderList, selectedItem: $selectedItem)
            ZStack {
                if selectedItem != nil {
                    DetailView(item: $selectedItem)
                } else {
                    Text("Select an item from the list.")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}
