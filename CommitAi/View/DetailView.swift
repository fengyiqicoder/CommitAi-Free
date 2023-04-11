//
//  DetailView.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/2.
//

import SwiftUI
import Cocoa


struct DetailView: View {
    @Binding var item: Item?
    
    @State private var commitText: String = ""
    @State private var detailLevel: String = Setting.shared.graininess
    @State private var language: String = Setting.shared.language
    @State private var isRefreshing = false

    @State private var uncommittedChanges: String = ""
    
    func commitAndRefresh() {
        guard let item = self.item else {return}
        if let repoPath = item.folderURL?.path {
            GitCenter.shared.stageAndCommitAllChanges(repoPath: repoPath, commitMessage: commitText)
            updateInfo()
            FolderList.shared.sendToFirst(item: item)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    //需要优化显示
                    ReadOnlyTextEditor(text: $uncommittedChanges)
                }
                .font(.body)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.66, alignment: .center)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .onChange(of: item) { _ in
                    self.updateInfo()
                }
                .onAppear(){
                    self.updateInfo()
                }
                Divider()
                VStack {
                    ZStack {
                        
                        TextEditor(text: $commitText)
                            .font(.system(size: 14))
                            .padding(EdgeInsets(top: 2, leading: 8, bottom: 0, trailing: 8))
                            .border(Color.clear, width: 0)
                        
                        if isRefreshing {
                            Color.black.opacity(0.4)
                                .cornerRadius(4)
                                .disabled(isRefreshing)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())

                        }
                    }
                    
                    HStack {
                        Picker("", selection: $detailLevel) {
                            Text("Detailed").tag("Detailed")
                            Text("Concise").tag("Concise")
                            Text("Rough").tag("Rough")
                            Text("Brief").tag("Brief")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.gray)
                        .frame(width: 100)
                        .onChange(of: detailLevel) { newValue in
                            Setting.shared.graininess = newValue
                            updateInfo()
                        }

                        Picker("", selection: $language) {
                            Text("English").tag("English")
                            Text("Chinese").tag("Chinese")
                            Text("Spanish").tag("Spanish")
                            Text("German").tag("German")
                            Text("French").tag("French")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.gray)
                        .frame(width: 100)
                        .onChange(of: language) { newValue in
                            Setting.shared.language = newValue
                            updateInfo()
                        }

                        Spacer()
            
                        Button(action: {
                            guard !isRefreshing else { return }
                            FolderList.shared.updateFoldersBranchName()
                            updateInfo()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.secondary)
                                .rotationEffect(.degrees(isRefreshing ? 360 : 0), anchor: .center)
                                .animation(.linear(duration: isRefreshing ? 0.6 : 0), value: isRefreshing)
                        }
                        .buttonStyle(PlainButtonStyle())

                        
                        Button(action: {
                            EventTracker.shared.trackMac(eventName: EventTracker.CommitMessage)
                            commitAndRefresh()
                        }) {
                            Text("Commit ⌘+⏎")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 14)
                        }
//                        .background(.blue)
                        .background(Color.blue.edgesIgnoringSafeArea(.all))

                        .cornerRadius(4)
                        .padding(.horizontal, 12)
                        .keyboardShortcut(KeyEquivalent.return, modifiers: .command)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 12)
                }
                .frame(height: geometry.size.height * 0.3, alignment: .top)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

extension DetailView {
    func updateInfo() {
        if let repoPath = self.item?.folderURL?.path {
            let fileStr = GitCenter.shared.fetchUncommittedChanges(repoPath: repoPath) ?? ""
            let changeDetailStr = GitCenter.shared.fetchUncommittedChangesDetails(repoPath: repoPath) ?? ""
            guard !fileStr.isEmpty else {
                uncommittedChanges = "\(item?.title ?? "") Has no uncommitted changes"
                commitText = "No Message"
                return
            }
            
            uncommittedChanges = fileStr + "\n" + changeDetailStr
            
            let maxSentenceCount = 20
            let inputMessage = reprocessing(fileMessage: fileStr, detailMessage: changeDetailStr)
            let prompt = """
            You are a programmer who knows how to write commit messages.
            You need to summarize the information output from the following Git in a concise and clear manner,
            using no more than \(Setting.shared.graininess.graininessLevel) sentences.
            No sentence should exceed \(maxSentenceCount) words.
            You must provide the summary within this response.
            The tone of this summary must imitate the common Git Commit Message.
            Do not provide the colon and the explanation before the colon
            Git Message:
            \"\"\"
            \(inputMessage)
            \"\"\"
            Use \(Setting.shared.language) to give information
            """
            isRefreshing = true
            AI.shared.ask(question: prompt) { answer in
                DispatchQueue.main.async {
                    commitText = answer ?? "Something Wrong"
                    isRefreshing = false
                }
            }
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView(item: Item(title: "Sample Item", subtitle: "Sample Subtitle"))
//    }
//}
