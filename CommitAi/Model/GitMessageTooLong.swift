//
//  GitMessageTooLong.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/5.
//

import Foundation

//Token超出？进行字符检查，太长就仅发送增加的代码，还是太长就仅发送文件编辑信息
fileprivate
let gitMessageMaxCount = 7400

func reprocessing(fileMessage: String, detailMessage: String) -> String {
    let fileMessage = fileMessage + "\n"
    if (fileMessage + detailMessage).count < gitMessageMaxCount {
        return fileMessage + detailMessage
    } else {
        //按照级别缩短
        let message = process(detailMessage: detailMessage)
        if (fileMessage + message.combinedTitlesAndAddedAndDeteleLines).count < gitMessageMaxCount {
            return fileMessage + message.combinedTitlesAndAddedAndDeteleLines
        } else if (fileMessage + message.combinedTitlesAndAddLines).count < gitMessageMaxCount {
            return fileMessage + message.combinedTitlesAndAddLines
        }
        return fileMessage
    }
}

fileprivate
struct DetailGitMessage {
    var titles: [String] = []
    var addedLines: [String] = []
    var deletedLines: [String] = []
    
    
    var combinedTitlesAndAddedAndDeteleLines: String {
        return (titles + addedLines + deletedLines).joined(separator: "\n")
    }

    var combinedTitlesAndAddLines: String {
        return (titles + addedLines).joined(separator: "\n")
    }

    var combinedTitles: String {
        return titles.joined(separator: "\n")
    }
}


fileprivate
func process(detailMessage: String) -> DetailGitMessage {
    var result = DetailGitMessage()
    let lines = detailMessage.split(separator: "\n")
    
    for line in lines {
        let currentLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if currentLine.hasPrefix("@@") {
            result.titles.append(String(currentLine))
        } else if currentLine.hasPrefix("+") {
            result.addedLines.append(String(currentLine))
        } else if currentLine.hasPrefix("-") {
            result.deletedLines.append(String(currentLine))
        }
    }
    
    return result
}
