//
//  File.swift
//  
//
//  Created by ミズキ on 2022/11/14.
//
import FirebaseFirestore

protocol FirebaseTargetType {
    associatedtype FirebaseModel:
    var id: String { get }
    var ref: FIRCollectionReference { get }
}
