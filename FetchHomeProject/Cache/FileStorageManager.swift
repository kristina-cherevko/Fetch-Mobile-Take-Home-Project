//
//  FileStorageManager.swift
//  FetchHomeProject
//
//  Created by Kristina Cherevko on 4/14/25.
//

import Foundation

final class FileStorageManager {
    static let shared = FileStorageManager()
    private let fileManager = FileManager.default
    private var cacheDirectoryURL: URL? { fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first }
    
    private init() {}
    
    func retrieve(with fileName: String) -> ImageItem? {
        guard let cacheDirectoryURL = cacheDirectoryURL else { return nil }
        let fileURL = cacheDirectoryURL.appendingPathComponent(fileName + ".image.cache")
        guard let data = try? Data(contentsOf: fileURL),
              let item = try? JSONDecoder().decode(ImageItem.self, from: data) else {
            #if DEBUG
            print("Failed to get file \(fileName) from disk")
            #endif
            return nil
        }
        #if DEBUG
        print("Succesfully got file \(fileName) from disk")
        #endif
        return item
    }
    
    func save(_ imageItem: ImageItem) {
        guard let cacheDirectoryURL = cacheDirectoryURL else { return }
        let fileURL = cacheDirectoryURL.appendingPathComponent(imageItem.name + ".image.cache")
        #if DEBUG
        print("Creating path for file > \(fileURL)")
        #endif
        do {
            let data = try JSONEncoder().encode(imageItem)
            try data.write(to: fileURL)
            #if DEBUG
            print("Saved item to disk with name \(imageItem.name)")
            #endif
        } catch {
            #if DEBUG
            print(error)
            #endif
        }
    }
    
    func remove(with fileName: String) {
        guard let cacheDirectoryURL = cacheDirectoryURL else { return }
        let cacheFile = cacheDirectoryURL.appendingPathComponent(fileName + ".image.cache")
        if fileManager.fileExists(atPath: cacheFile.path) {
            do {
                try fileManager.removeItem(at: cacheFile)
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
    }
    
    func clearStorage() {
        guard let cacheDirectoryURL = cacheDirectoryURL else { return }
        do {
            if fileManager.fileExists(atPath: cacheDirectoryURL.path) {
                let contents = try fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil)
                for file in contents {
                    try fileManager.removeItem(at: file)
                }
            }
        } catch {
            print("Error clearing storage: \(error)")
        }
    }
}

extension FileStorageManager {
    struct ImageItem: Codable {
        let data: Data
        let name: String
        
        init(name: String, data: Data) {
            self.data = data
            self.name = name
        }
    }
}

