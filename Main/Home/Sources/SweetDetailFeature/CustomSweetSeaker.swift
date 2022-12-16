//
//  File.swift
//  
//
//  Created by ミズキ on 2022/12/16.
//

import SwiftUI
import SceneKit
import ComposableArchitecture

struct CustomSweetSeaker: View {
    @GestureState var offset: CGFloat
    let store: StoreOf<SweetDetailFeature>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            GeometryReader { _ in
                Rectangle()
                    .trim(from: 0, to: 0.474)
                    .stroke(.linearGradient(colors:
                                                [
                                                    .clear,
                                                    .clear,
                                                    .white.opacity(0.2),
                                                    .white.opacity(0.6),
                                                    .white,
                                                    .white.opacity(0.6),
                                                    .white.opacity(0.2),
                                                    .clear, .clear
                                                ],
                                            startPoint: .leading,
                                            endPoint: .trailing),
                            style: StrokeStyle(lineWidth: 2,
                                               lineCap: .round,
                                               lineJoin: .round,
                                               miterLimit: 1,
                                               dash: [3],
                                               dashPhase: 1))
                    .offset(x: viewStore.offset)
                    .overlay {
                        // MARK: SeekerView
                        HStack(spacing: 3) {
                            Image(systemName: "arrowtriangle.left.fill")
                                .font(.caption)
                            Image(systemName: "arrowtriangle.right.fill")
                                .font(.caption)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 10)
                        .background {
                            RoundedRectangle(cornerRadius: 10,
                                             style: .continuous)
                                .fill(.white)
                        }
                        .offset(y: -12)
                        .offset(x: viewStore.offset)
                        .gesture(
                            DragGesture()
                                .updating($offset,
                                          body: { value, out, _ in
                                    out = value.location.x - 20
                                })
                        )
                    }
            }
            .frame(height: 20)
            .onChange(of: offset,
                      perform: { newValue in
                viewStore.send(.changeOffset(newValue))
                viewStore.send(.rotateObject(isOffsetZero: offset == .zero))
            })
            .animation(.easeInOut(duration: 0.4),
                       value: viewStore.offset == .zero)
        }
    }
}
    

