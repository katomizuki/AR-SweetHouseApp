//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/27.
//

import QuickLookThumbnailing
import SwiftUI
import ComposableArchitecture

extension DependencyValues {
    public var thumbNailGenerator: ThumbnailGenerator {
        get { self[ThumbnailGenerator.self] }
        set { self[ThumbnailGenerator.self] = newValue }
    }
}

extension ThumbnailGenerator: DependencyKey {
    public static var liveValue: ThumbnailGenerator {
        return ThumbnailGenerator()
    }
}

public struct ThumbnailGenerator {
    private func generateThumbnail(for resource: String,
                                 withExtension: String = "usdz",
                                 size: CGSize,
                                 completion: @escaping(Result<Image, Error>) -> Void)  {
        guard let url = Bundle.main.url(forResource: resource, withExtension: withExtension)
        else {
            completion(.failure(QLThumbnailError(.savingToURLFailed)))
            return
        }
        let scale = UIScreen.main.scale
        let request = QLThumbnailGenerator.Request(fileAt: url,
                                                   size: size,
                                                   scale: scale,
                                                   representationTypes: .all)
        let generator = QLThumbnailGenerator.shared
        
        generator.generateRepresentations(for: request) { thumbnailRepresentation, type, error in
            if let thumbnailRepresentation = thumbnailRepresentation {
                let thumbnail = Image(uiImage: thumbnailRepresentation.uiImage)
                completion(.success(thumbnail))
            } else {
                completion(.failure(QLThumbnailError(.generationFailed)))
            }
        }
    }
    
    public init() { }
    
    public func generateThumnail(for resource: String, size: CGSize) async throws -> Image {
        try await withCheckedThrowingContinuation({ continuation in
            self.generateThumbnail(for: resource, size: size) { result in
                do {
                    let image = try result.get()
                    continuation.resume(returning: image)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}


