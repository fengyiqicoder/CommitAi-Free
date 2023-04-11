//
//  AppAnalytis.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/9.
//


import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

class EventTracker {
    static let shared = EventTracker()
    
    func start() {
        //AppCenter
        AppCenter.start(withAppSecret: "7a1a0dd4-6ac9-4205-8c06-3a29cd2f7bd0", services:[
          Analytics.self,
          Crashes.self
        ])
    }
    
    func trackMac(eventName: String, withProperties: [String: String] = [:]) {
        var properties = withProperties
        eventNameCountDict[eventName] = (eventNameCountDict[eventName] ?? 0) + 1
        let count = eventNameCountDict[eventName]!
        var frequencyName = ""
        if 0 < count, count < 10 {
            frequencyName = "1~10"
        } else if 10 <= count, count < 100 {
            frequencyName = "10~100"
        } else if 100 <= count, count < 500 {
            frequencyName = "100~500"
        } else if 500 <= count {
            frequencyName = ">500"
        }
        properties["frequencyType"] = frequencyName
        Analytics.trackEvent(eventName, withProperties: properties)
    }
    
    func trackiOS(eventName: String, withProperties: [String: String] = [:]) {
        var properties = withProperties
        eventNameCountDict[eventName] = (eventNameCountDict[eventName] ?? 0) + 1
        let count = eventNameCountDict[eventName]!
        var frequencyName = ""
        if 0 < count, count < 10 {
            frequencyName = "1~10"
        } else if 10 <= count, count < 100 {
            frequencyName = "10~100"
        } else if 100 <= count, count < 500 {
            frequencyName = "100~500"
        } else if 500 <= count {
            frequencyName = ">500"
        }
        properties["frequencyType"] = frequencyName
        Analytics.trackEvent(eventName, withProperties: properties)
    }
    
    private var eventNameCountDict: [String: Int] {
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: "eventNameCountDict")
        }
        get {
            
            let data = (UserDefaults.standard.object(forKey: "eventNameCountDict") as? Data) ?? Data()
            return (try? JSONDecoder().decode([String: Int].self, from: data)) ?? [:]
        }
    }

}

extension EventTracker {
    static let StartApp = "StartApp"
    static let CloseApp = "CloseApp"
    
    static let CommitMessage = "CommitMessage"
}
