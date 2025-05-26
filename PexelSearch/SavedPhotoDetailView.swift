//
//  SavedPhotoDetailView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/22.
//

import SwiftUI

struct SavedPhotoDetailView: View {
    let photo: SavedPhoto
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Group {
                if let data = photo.imageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                }
            }
            .padding()

            Text("Photographer: \(photo.photographer)")
                .font(.headline)
                .padding(.top, 4)

            Text(photo.alt)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(role: .destructive, action: {
                modelContext.delete(photo)
                dismiss()
            }) {
                Label("Delete", systemImage: "trash")
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .presentationDetents([.large])
    }
}

#Preview {
    SavedPhotoDetailView()
}
