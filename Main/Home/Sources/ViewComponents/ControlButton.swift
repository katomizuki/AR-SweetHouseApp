
import SwiftUI

public struct ControlButton: View {
    public let systemName: String
    public let action: (() -> Void)
    
    public init(systemName: String,
                action: @escaping () -> Void) {
        self.systemName = systemName
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
           action()
        }, label: {
            Image(systemName: systemName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        })
        .frame(width: 50, height: 50)
    }
}
