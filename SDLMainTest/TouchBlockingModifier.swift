import SwiftUI
import UIKit

// MARK: - Touch Blocking View Modifier

/// A SwiftUI view modifier that prevents touches from passing through to layers below
/// while allowing the view's own interactive elements to function normally.
extension View {
    /// Prevents touches from passing through this view to layers below (like SDL).
    /// 
    /// - Parameters:
    ///   - backgroundColor: The background color for the touch-blocking area
    ///   - cornerRadius: The corner radius for the background
    /// - Returns: A view that blocks touches from reaching layers below
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

// MARK: - Touch Blocking UIView (for advanced use cases)

/// A UIView that blocks all touch events from passing through to views below
class TouchBlockingView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        // If we hit any subview, return it; otherwise return self to block touches
        return hitView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Consume the touch event - don't call super to prevent propagation
        print("TouchBlockingView: touchesBegan - blocking touch event")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Consume the touch event - don't call super to prevent propagation
        print("TouchBlockingView: touchesMoved - blocking touch event")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Consume the touch event - don't call super to prevent propagation
        print("TouchBlockingView: touchesEnded - blocking touch event")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Consume the touch event - don't call super to prevent propagation
        print("TouchBlockingView: touchesCancelled - blocking touch event")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // Always return true to capture all touches in this view's bounds
        return super.point(inside: point, with: event)
    }
}

// MARK: - Touch Blocking Background (UIViewRepresentable)

/// A UIViewRepresentable that creates a TouchBlockingView as a background
struct TouchBlockingBackground: UIViewRepresentable {
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    func makeUIView(context: Context) -> TouchBlockingView {
        let view = TouchBlockingView()
        view.backgroundColor = UIColor(backgroundColor)
        view.layer.cornerRadius = cornerRadius
        view.isUserInteractionEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: TouchBlockingView, context: Context) {
        uiView.backgroundColor = UIColor(backgroundColor)
        uiView.layer.cornerRadius = cornerRadius
    }
}