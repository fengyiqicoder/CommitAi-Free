//
//  FolderCenter.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/3.
//

import SwiftUI

class FolderList: ObservableObject {
    static let shared = FolderList()
    
    @Published var folders: [Item] {
        didSet {
            saveFoldersToUserDefaults()
        }
    }
    
    private let userDefaultsKey = "FolderStorage"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) ,
           let decodedFolders = try? JSONDecoder().decode([Item].self, from: data) {
            
            folders = decodedFolders
        } else {
            folders = []
        }
    }
    
    func addFolder(url: URL) {
        let title = url.lastPathComponent
        var subtitle = GitCenter.shared.fetchBranchName(repoPath: url.path) ?? ""
        subtitle = subtitle.isEmpty ? "No Git" : subtitle
        let newItem = Item(title: title, subtitle: subtitle, folderURL: url)
        self.folders.append(newItem)
    }
    
    func sendToFirst(item: Item) {
        if let index = folders.firstIndex(where: { $0.id == item.id }) {
            folders.remove(at: index)
            folders.insert(item, at: 0)
        }
    }

    
    func updateFoldersBranchName() {
        folders.enumerated().forEach { (index, folder) in
            guard let url = folder.folderURL else { return }
            var subtitle = GitCenter.shared.fetchBranchName(repoPath: url.path) ?? ""
            subtitle = subtitle.isEmpty ? "No Git" : subtitle
            folders[index].subtitle = subtitle
        }
    }
    
    private func saveFoldersToUserDefaults() {
        do {
            let encodedFolders = try JSONEncoder().encode(folders)
            UserDefaults.standard.set(encodedFolders, forKey: userDefaultsKey)
        } catch {
            print("Error encoding folders: \(error)")
        }
    }
    
}
