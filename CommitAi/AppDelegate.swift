//
//  AppDelegate.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/3/31.
//

import Cocoa
import OpenAI
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
//    var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        let window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        window.center()
//        window.setFrameAutosaveName("Main Window")
//        window.contentView = NSHostingView(rootView: MainView())
//        window.makeKeyAndOrderFront(nil)
//        self.window = window
        
        MainWindowController.show()
        
        EventTracker.shared.start()
        EventTracker.shared.trackMac(eventName: EventTracker.StartApp)
    }

    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        MainWindowController.show()
        return true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        EventTracker.shared.trackMac(eventName: EventTracker.CloseApp)
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}

        
        // 构建对话记录
//        print("prompts")
//        print(prompts)
//        var messages: [OpenAI.Chat] = []
//        for i in 0..<prompts.count {
//            if i == prompts.count - 1 {
//                messages.append(.init(role: "user", content: prompts[i].issue))
//                break
//            }
//            messages.append(.init(role: "user", content: prompts[i].issue))
//            messages.append(.init(role: "assistant", content: prompts[i].answer ?? ""))
//        }
//        print("message:")
//        print(messages)
//        let model = prompts.last?.model ?? "gpt-3.5-turbo"
//        print("model:")
//        print(model)
//        openAI.chats(query: .init(model: model, messages: messages), timeoutInterval: 30) { data in
//            print("data:")
//            print(data)
//            do {
//                let res = try data.get().choices[0].message.content
//                DispatchQueue.main.async {
//                    completion(res)
//                }
//            } catch {
//                print(error)
//                let errorMessage = error.localizedDescription
//                DispatchQueue.main.async {
//                    completion(errorMessage)
//                }
//            }
//        }
