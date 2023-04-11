//
//  Ex.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/2.
//

import Cocoa


extension NSScreen {
    func getCenterFrame(with size: CGSize) -> CGRect {
        if let mainSize = NSScreen.main?.frame.size {
            let x = mainSize.width/2 - size.width/2
            let y = mainSize.height/2 - size.height/2
            return CGRect(x: x, y: y, width: size.width, height: size.height)
        }
        return CGRect.zero
    }
}
