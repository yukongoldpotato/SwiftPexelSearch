//
//  PhotoDetailView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: Photo
    let isSaved: Bool
    let toggleSave: () -> Void

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: photo.src.large)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
                        .cornerRadius(15)
                default:
                    EmptyView()
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

            Text("\(photo.width) × \(photo.height) px")
                .font(.footnote)
                .foregroundColor(.secondary)

            if let pexelsURL = URL(string: photo.url) {
                Link("View on Pexels", destination: pexelsURL)
                    .font(.footnote)
            }

            Button(action: toggleSave) {
                Label(isSaved ? "Saved" : "Save",
                      systemImage: isSaved ? "bookmark.fill" : "bookmark")
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Spacer()
        }
        .presentationDetents([.large])
    }
}

#Preview {
    PhotoDetailView()
}
