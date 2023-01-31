//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/16.
//

import SwiftUI
import ComposableArchitecture

struct PropertiesSweetView: View {
    
    private let store: StoreOf<SweetDetailFeature>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                VStack(alignment: .leading,
                       spacing: 12) {
                    Text(viewStore.state.sweet.name)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.orange)
                }
                .padding(.top, 10)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                VStack(alignment: .center) {
                    VStack(alignment: .leading,
                           spacing: 10) {
                        Text(viewStore.state.sweet.description)
                            .font(.callout)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.gray)

                    }
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                
                    Spacer()
                    
                    Button {
                        viewStore.send(.onTapDecideButton)
                    } label: {
                        VStack(alignment: .center,
                               content: {
                            VStack(spacing: 12) {
                                Image(systemName: "plus.square.dashed")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45,
                                           height: 45)
                            }
                            .foregroundColor(.black)
                            .padding(18)
                            .background {
                                RoundedRectangle(cornerRadius: 20,
                                                 style: .continuous)
                                    .fill(.white)
                            }
                            
                            Text("Place in ARWorld")
                                .fontWeight(.semibold)
                                .padding(.top, 20)
                                .foregroundColor(.orange)
                        })
                    }
                }
                .padding(.top, 30)
            }
        }
    }

    init(store: StoreOf<SweetDetailFeature>) {
        self.store = store
    }
}
