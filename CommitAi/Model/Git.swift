//
//  Git.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/3.
//

import Foundation

class GitCenter {
    
    static let shared = GitCenter()
    
//    func test() {
//        print("Testing Git")
        
        // 调用此函数并提供Git仓库路径
//        let fileURL = "/Users/fengyq/Desktop/FileAI"
//        fetchRepoInfo(repoPath: fileURL)
//        stageAndCommitAllChanges(repoPath: fileURL, commitMessage: "hello")
//    }
    
    func executeGitCommand(arguments: [String], repoPath: String) -> String? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.currentDirectoryURL = URL(fileURLWithPath: repoPath)
        process.arguments = arguments

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        do {
            try process.run()
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: outputData, as: UTF8.self)
            return output.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            print("Error running git command: \(error)")
            return nil
        }
        
    }
    

    func stageAndCommitAllChanges(repoPath: String, commitMessage: String) {
        // Stage所有变化
        if executeGitCommand(arguments: ["add", "--all"], repoPath: repoPath) != nil {
            print("All changes staged.")
        } else {
            print("Error staging changes.")
            return
        }

        // Commit变化并添加commit message
        if executeGitCommand(arguments: ["commit", "-m", commitMessage], repoPath: repoPath) != nil {
            print("Changes committed with message: '\(commitMessage)'.")
        } else {
            print("Error committing changes.")
        }
    }

    func fetchBranchName(repoPath: String) -> String? {
        return executeGitCommand(arguments: ["rev-parse", "--abbrev-ref", "HEAD"], repoPath: repoPath)
    }

    func fetchUncommittedChanges(repoPath: String) -> String? {
        return executeGitCommand(arguments: ["status", "--short"], repoPath: repoPath)
    }

    func fetchUncommittedChangesDetails(repoPath: String) -> String? {
        return executeGitCommand(arguments: ["diff"], repoPath: repoPath)
    }

    
}



//    func fetchRepoInfo(repoPath: String) {
//        // 获取当前分支
//        if let branchName = executeGitCommand(arguments: ["rev-parse", "--abbrev-ref", "HEAD"], repoPath: repoPath) {
//            print("Current branch: \(branchName)")
//        }
//
//        // 获取尚未提交的文件状态
//        if let statusOutput = executeGitCommand(arguments: ["status", "--short"], repoPath: repoPath) {
//            if statusOutput.isEmpty {
//                print("No uncommitted changes.")
//            } else {
//                print("Uncommitted changes:")
//                print(statusOutput)
//            }
//        }
//
//        // 获取尚未提交的详细更改（可选）
//        if let diffOutput = executeGitCommand(arguments: ["diff"], repoPath: repoPath) {
//            if !diffOutput.isEmpty {
//                print("Uncommitted changes details:")
//                print(diffOutput)
//            }
//        }
    // 获取最近一次提交的信息
//        if let commitInfo = executeGitCommand(arguments: ["log", "-1", "--pretty=format:%h %an <%ae> %s %cd"], repoPath: repoPath) {
//            print("Latest commit info: \(commitInfo)")
//        }
//    }
