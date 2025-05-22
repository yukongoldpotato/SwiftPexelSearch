//
//  SavedPhotoDetailView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/22.
//

import SwiftUI

struct SavedPhotoDetailView: View {
    let photo: SavedPhoto

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
        }
        .presentationDetents([.large])
    }
}

#Preview {
    SavedPhotoDetailView()
}
