//
//  ImageFileCache.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 18/09/25.
//


import SwiftUI
import CryptoKit
import UIKit

/// A small file-cache helper that stores image data in the user's caches directory.
final class ImageFileCache {
    static let shared = ImageFileCache()

    private let fileManager = FileManager.default
    private let folderName = "ImageCache"
    private lazy var cacheDirectoryURL: URL = {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let base = urls[0]
        let folder = base.appendingPathComponent(folderName, isDirectory: true)
        if !fileManager.fileExists(atPath: folder.path) {
            try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        return folder
    }()

    private init() {}

    func fileURL(for url: URL) -> URL {
        // Use SHA256 of the absoluteString as filename (safe & unique)
        let name = sha256(url.absoluteString)
        return cacheDirectoryURL.appendingPathComponent(name)
    }

    func loadImage(for url: URL) -> UIImage? {
        let file = fileURL(for: url)
        guard fileManager.fileExists(atPath: file.path) else { return nil }
        guard let data = try? Data(contentsOf: file) else { return nil }
        return UIImage(data: data)
    }

    func save(data: Data, for url: URL) {
        let file = fileURL(for: url)
        // atomic write
        try? data.write(to: file, options: .atomic)
    }

    func exists(for url: URL) -> Bool {
        fileManager.fileExists(atPath: fileURL(for: url).path)
    }

    func clearCache() {
        try? fileManager.removeItem(at: cacheDirectoryURL)
        try? fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
    }

    private func sha256(_ string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
