//
//  SavedView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI
import SwiftData
import WaterfallGrid

struct SavedView: View {
    @Query var saved: [SavedPhoto]
    @State private var selectedPhoto: SavedPhoto?

    var body: some View {
        NavigationStack {
            ScrollView {
                WaterfallGrid(saved, id: \.id) { photo in
                    Group {
                        if let data = photo.imageData,
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                        }
                    }
                    .onTapGesture {
                        selectedPhoto = photo
                    }
                }
                .gridStyle(columns: 2, spacing: 6)
                .padding(6)
            }
            .navigationTitle("Saved")
            .sheet(item: $selectedPhoto) { selected in
                SavedPhotoDetailView(
                    photo: selected
                )
            }
        }
    }
}

#Preview {
    SavedView()
}
