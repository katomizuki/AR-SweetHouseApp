//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/11.
//

import SwiftUI
import ViewComponents

struct HomeControlButtonsBarView: View {
    var body: some View {
        HStack(alignment: .center,
               content: {
            HomeControlsButtons()
        })
    }
}

struct HomeControlsButtons: View {
    var body: some View {
        HStack(content: {
            ControlButton(systemName: "square.grid.2x2", action: {
                print("ウエーい")
            })
            Spacer()
            
            ControlButton(systemName: "square.grid.2x2", action: {
                print("タプ")
            })
            Spacer()
            
            ControlButton(systemName: "square.grid.2x2", action: {
                print("タプ")
            })
        })
        .frame(maxWidth: 500)
        .padding(30)
        .background(.black.opacity(0.25))
    }
}
