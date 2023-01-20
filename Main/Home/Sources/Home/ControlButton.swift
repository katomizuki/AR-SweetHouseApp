
import SwiftUI

public struct ControlButton: View {
    public let systemName: String
    public let action: (() -> Void)
    public let buttonTitle: String
    
    public init(systemName: String,
                buttonTitle: String,
                action: @escaping () -> Void) {
        self.systemName = systemName
        self.action = action
        self.buttonTitle = buttonTitle
    }
    
    public var body: some View {
        VStack(alignment: .center,
               content: {
            Button(action: {
               action()
            }, label: {
                Image(systemName: systemName)
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            })
            .frame(width: 50,
                   height: 50)
            
            Text(buttonTitle)
                .font(.footnote)
        })
    }
}
