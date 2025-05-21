//
//  SavedView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI
import SwiftData

struct SavedView: View {
    @Query var saved: [SavedPhoto]

    var body: some View {
        NavigationStack {
            //TODO: enable saving multiple images later
            if let data = saved.first?.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text("Saved items will appear here.")
                .navigationTitle("Saved")
        }
    }
}

#Preview {
    SavedView()
}
