//
//  FNCachedAsyncImage.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 18/09/25.
//

import SwiftUI

/// A SwiftUI view that shows a cached image if present, otherwise uses AsyncImage
/// to fetch, display, and save the remote image to FileManager cache.
struct FNCachedAsyncImage<Placeholder: View>: View {
    let url: URL?
    let scale: CGFloat
    let contentMode: ContentMode
    let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?
    @State private var didStartSaving = false

    init(
        url: URL?,
        scale: CGFloat = 1.0,
        contentMode: ContentMode = .fill,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
    ) {
        self.url = url
        self.scale = scale
        self.contentMode = contentMode
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let uiImage = uiImage {
                // If we have a cached image, render it
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                
            } else {
                // If not cached, use AsyncImage to download and show
                if let url = url {
                    AsyncImage(url: url, scale: scale) { phase in
                        switch phase {
                        case .empty:
                            placeholder()
                        case .success(let image):
                            // Show the image immediately
                            let rendered = image
                                .resizable()
                                .aspectRatio(contentMode: contentMode)
                            
                            rendered
                                .onAppear {
                                    // Save to disk if not already saved.
                                    // Because AsyncImage's Image doesn't give us Data,
                                    // we perform a separate URLSession data fetch to get the Data.
                                    saveImageDataIfNeeded(from: url)
                                }
                        case .failure:
                            placeholder()
                            
                        @unknown default:
                            placeholder()
                        }
                    }
                } else {
                    // no url provided
                    placeholder()
                }
            }
        }
        .onAppear {
            // Try load from disk when view appears
            guard let url = url else { return }
            if let cached = ImageFileCache.shared.loadImage(for: url) {
                self.uiImage = cached
            }
        }
    }

    /// If file not present, perform a data fetch and save bytes.
    /// This avoids relying on AsyncImage internals for data access.
    private func saveImageDataIfNeeded(from url: URL) {
        // Avoid re-triggering multiple downloads for the same view instance.
        if didStartSaving { return }
        didStartSaving = true

        // If already stored, nothing to do
        if ImageFileCache.shared.exists(for: url) {
            // We still set uiImage so view updates to the cached image style.
            if let cached = ImageFileCache.shared.loadImage(for: url) {
                DispatchQueue.main.async {
                    self.uiImage = cached
                }
            }
            return
        }

        // Fetch image data and save
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, !data.isEmpty else { return }
            ImageFileCache.shared.save(data: data, for: url)
            if let savedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = savedImage
                }
            }
        }
        task.resume()
    }
}
