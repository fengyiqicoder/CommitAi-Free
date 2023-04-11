//
//  GPT.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/3/31.
//

import Foundation
import OpenAI

class AI {
    static let shared = AI()
    //需要进行配置
    static var apiKey: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "AI.apiKey")
        }
        get {
            (UserDefaults.standard.object(forKey: "AI.apiKey") as? String)
        }
    }
    
    var character: [OpenAI.Chat] {
        set {
            UserDefaults.standard.set(newValue, forKey: "AI.character")
        }
        get {
            (UserDefaults.standard.object(forKey: "AI.character") as? [OpenAI.Chat]) ?? []
        }
    }
    private(set) var currentChat: [OpenAI.Chat] = []
    
    
    //对外接口
    var instance: OpenAI? {
        guard let key = Self.apiKey else { return nil }
        let openAI = OpenAI(apiToken: key)
        return openAI
    }
    
    func ask(question: String, answer: @escaping (String?) -> Void) {
        guard let ai = instance else { return }
        //Max token 问题警告
        print("Question count \(question.count)")
        let query = OpenAI.ChatQuery(model: .gpt3_5Turbo,
                                     messages: character + [.init(role: "user", content: question), .init(role: "user", content: question)])
        ai.chats(query: query) { data in
            if case let .success(result) = data {
                answer(result.choices.first?.message.content)
            } else if case let .failure(error) = data {
                answer(error.localizedDescription)
                print(data)
            }
        }
    }
    
}
