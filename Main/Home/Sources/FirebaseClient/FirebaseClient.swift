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
import ComposableArchitecture
import FirebaseStorage
import FirebaseFirestoreSwift
import Combine

extension DependencyValues{
    public var firebaseClient: FirebaseClient {
        get { self[FirebaseClient.self] }
        set { self[FirebaseClient.self] = newValue }
    }
}

extension FirebaseClient: DependencyKey {
    public static var liveValue: FirebaseClient {
        return FirebaseClient.shared
    }
}

public final class FirebaseClient {
    private init() { }
    public static let shared = FirebaseClient()
    private let db = Firestore.firestore().collection("sweets")
    private let storage = Storage.storage()
    private var cancellable: AnyCancellable?
    
    public func fetchSweets() async throws -> Sweets {
        let list = try await db.getDocuments()
            .documents
            .map({
                return try Firestore.Decoder().decode(Sweet.self, from: $0.data())
            })
        return Sweets(list: list)
    }

    private func fetchUsdzModel(url: URL,
                               completion: @escaping(Result<ModelEntity, Error>)-> Void) {
        self.cancellable = ModelEntity.loadModelAsync(contentsOf: url)
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished: break
                }
            }, receiveValue: { modelEntity in
                completion(.success(modelEntity))
            })
    }
    
    public func fetchUsdzModels(modelNames: [String]) async throws -> [ModelEntity] {
        try await withThrowingTaskGroup(of: ModelEntity.self, body: { group in
            for name in modelNames {
                group.addTask {
                    return try await self.fetchUsdzModel(name: name)
                }
            }
            var models = [ModelEntity]()
            for try await value in group {
                models.append(value)
            }
            return models
        })
    }
    
    private func fetchUsdzModel(name: String) async throws -> ModelEntity {
        let url = try await storage.reference(withPath: "models/\(name).usdz").downloadURL()
        return try await fetchUsdzModel(url: url)
    }
    
    private func fetchUsdzModel(url: URL) async throws -> ModelEntity {
        try await withCheckedThrowingContinuation({ continuation in
                self.fetchUsdzModel(url: url) { result in
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
