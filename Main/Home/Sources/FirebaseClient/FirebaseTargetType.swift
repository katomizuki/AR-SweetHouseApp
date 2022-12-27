//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/14.
//
import FirebaseFirestore
import ARKit
import RealityKit
import EntityModule
import SwiftUI

enum FirebaseError: Error {
    case error
    case notDocuments
}
public final class FirebaseClient {
    private init() { }
    public static let shared = FirebaseClient()
    private let db = Firestore.firestore().collection("sweets")
    
    private func getSweets(completion: @escaping(Result<Sweets, Error>) -> Void) {
        db.getDocuments { snapShot, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let documents = snapShot?.documents else {
                completion(.failure(FirebaseError.notDocuments))
                return
            }
            let list = documents.map({
                let data = $0.data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let thumbnailString = data["thumbnail"] as? String
                let sweet = Sweet(name: name,
                                  thumnail: Image(systemName: "square.and.arrow.up"),
                                  description: description)
                return sweet
            })
            completion(.success(Sweets(list: list)))
        }
    }
    
    public func getSweets() async throws -> Sweets {
        try await withCheckedThrowingContinuation({ continuation in
            self.getSweets { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
}
