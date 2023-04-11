//
//  TestingView.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/2.
//


import SwiftUI
import Cocoa

struct SidebarView: View {
    
    @ObservedObject var folderList: FolderList
    @Binding var selectedItem: Item?
    
    // 添加新的状态变量以控制弹窗的显示
    @State private var isShowingSettingsAlert = false
    @State private var openAIKey: String = AI.apiKey ?? ""
    
    var body: some View {
        VStack {
            List(selection: $selectedItem) {
                ForEach(folderList.folders) { item in
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        Text(item.title)
                            .font(.headline)
                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Divider() // 添加分割线
                    }
                    .frame(minHeight: 44)
                    .tag(item)
                    .onTapGesture {
                        selectedItem = item
                    }
                    .contextMenu {
                        Button(action: {
                            if let index = folderList.folders.firstIndex(where: { $0.id == item.id }) {
                                folderList.folders.remove(at: index)
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                
                Button(action: {
                    let openPanel = NSOpenPanel()
                    openPanel.canChooseFiles = false
                    openPanel.canChooseDirectories = true
                    openPanel.allowsMultipleSelection = false
                    openPanel.showsResizeIndicator = true
                    openPanel.showsHiddenFiles = false
                    openPanel.canChooseDirectories = true
                    openPanel.canCreateDirectories = false
                    openPanel.message = "Choose a project folder with Git"

                    openPanel.begin { result in
                        if result == .OK, let url = openPanel.url {
                            folderList.addFolder(url: url)
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Add Repo")
                            .font(.body)
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(height: 44)
            }
                .listStyle(SidebarListStyle())
            // 添加设置按钮
            HStack {
                
                Button(action: {
                    self.isShowingSettingsAlert.toggle()
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(EdgeInsets(top: 4, leading: 12, bottom: 6, trailing: 4))
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8))
        }
        .onAppear() {
            folderList.updateFoldersBranchName()
            if AI.apiKey == nil || AI.apiKey == "" {
                isShowingSettingsAlert = true
            }
        }
        .sheet(isPresented: $isShowingSettingsAlert) {
            VStack {
                Text("Enter OpenAI Key")
                    .font(.title2)
                    .padding(.top, 16)
                Text("We will only store your API locally.")
                    .foregroundColor(.gray)
                    .padding(.bottom, 16)
                    
                TextField("SK-XXXX", text: $openAIKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                Spacer()
                HStack {
                    Spacer()
                    Button("Cancel", action: {
                        self.isShowingSettingsAlert.toggle()
                    })
                    .padding(.all, 16)
                    Button("Save", action: {
                        // 保存 OpenAI Key
                        AI.apiKey = openAIKey
                        self.isShowingSettingsAlert.toggle()
                    })
                    .padding(.all, 16)
                }
            }
        }
    }
}

struct Item: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var subtitle: String
    var folderURL: URL?
}

//var items: [Item] = [
//    Item(title: "Item 1", subtitle: "Subtitle 1"),
//    Item(title: "Item 2", subtitle: "Subtitle 2"),
//    Item(title: "Item 3", subtitle: "Subtitle 3")
//]


//struct SidebarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarView(selectedItem: .constant(items.first))
//    }
//}
