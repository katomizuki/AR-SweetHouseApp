//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/14.
//

import SwiftUI

public struct ListCellWithImage: View {
    private let image: Image
    private let title: String
    
    public var body: some View {
        HStack(content: {
            image
                .resizable()
                .frame(width: 45, height: 45)
            Text(title)
                .font(.title2)
                .bold()
                .padding(.leading, 10)
        })
        .frame(height: 50)
    }
    
    public init(image: Image, title: String) {
        self.image = image
        self.title = title
    }
}
