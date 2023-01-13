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
                    
                    Text(viewStore.state.sweet.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        
                    Label {
                        Text(viewStore.state.sweet.name)
                            .fontWeight(.semibold)
                    } icon: {
                        Image(systemName: "star.fill")
                    }
                    .foregroundColor(Color.orange)

                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
                HStack(alignment: .top) {
                    Button {
                        
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.square.dashed")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 45,
                                       height: 45)
                            
                            Text("Decide!!")
                                .fontWeight(.semibold)
                                .padding(.top, 20)
                        }
                        .foregroundColor(.black)
                        .padding(18)
                        .background {
                            RoundedRectangle(cornerRadius: 20,
                                             style: .continuous)
                                .fill(.white)
                        }
                    }
                    VStack(alignment: .leading,
                           spacing: 10) {
                        Text(viewStore.state.sweet.description)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)

                    }
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                }
                .padding(.top, 30)
            }
        }
    }

    init(store: StoreOf<SweetDetailFeature>) {
        self.store = store
    }
}
