//
//  Setting.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/5.
//

import Foundation

class Setting: ObservableObject {
    static let shared = Setting()
    
    init() {
        language = UserDefaults.standard.string(forKey: "Setting.language") ?? "English"
        graininess = UserDefaults.standard.string(forKey: "Setting.graininess") ?? "Rough"
    }
    
    @Published var language: String {
        didSet {
            UserDefaults.standard.set(language, forKey: "Setting.language")
        }
    }
    
    
    @Published var graininess: String {
        didSet {
            UserDefaults.standard.set(graininess, forKey: "Setting.graininess")
        }
    }
}

extension String {
    var graininessLevel: Int {
        if self == "Brief" {
            return 1
        } else if self == "Rough" {
            return 2
        } else if self == "Concise" {
            return 3
        } else if self == "Detailed" {
            return 4
        } else {
            return 2
        }
    }
}
