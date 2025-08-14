import SwiftUI
import UIKit

extension View {
    func blockingTouchesUnderneath(
        backgroundColor: Color = Color.black.opacity(0.4),
        cornerRadius: CGFloat = 12
    ) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .simultaneousGesture(
                // This gesture captures all touches in this area without interfering
                // with the view's own interactive elements (like buttons)
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        // Consume the touch event - prevents it from reaching SDL
                    }
                    .onEnded { _ in
                        // Consume the touch event - prevents it from reaching SDL
                    }
            )
    }
}
