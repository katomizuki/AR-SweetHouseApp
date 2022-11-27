//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/27.
//

import QuickLookThumbnailing
import SwiftUI

struct ThumnailGenerator {
    private func generateThumnail(for resource: String,
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
    
    func generateThumnail(for resource: String, size: CGSize) async throws -> Image {
        try await withCheckedThrowingContinuation({ continuation in
            self.generateThumnail(for: resource, size: size) { result in
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
