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
    
    public func getSweets() async throws -> Sweets {
        let list = try await db.getDocuments()
            .documents
            .map({
                return try Firestore.Decoder().decode(Sweet.self, from: $0.data())
            })
        return Sweets(list: list)
    }
    
}
