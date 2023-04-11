//
//  DisableTextEditer.swift
//  CommitAi
//
//  Created by Edmund Feng on 2023/4/4.
//

import SwiftUI

struct ReadOnlyTextEditor: View {
    @Binding var text: String

    var body: some View {
        ZStack {
            TextEditor(text: $text)
                .opacity(0)

            ScrollView {
                Text(text)
            }

            Color.clear
                .allowsHitTesting(false)
        }
    }
}
