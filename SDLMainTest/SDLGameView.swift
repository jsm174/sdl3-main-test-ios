import SwiftUI

struct SDLGameView: View {
    var body: some View {
        ZStack {
            // SDL content area - allows touches to pass through
            Color.clear
                .allowsHitTesting(false)
            
            // UI overlay in corner - blocks touches only in this area
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Game Controls")
                            .font(.headline)
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Text("Touch to move square")
                            .font(.caption)
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                        
                        Button("Back to Menu") {
                            SDLSwiftUIBridge.shared.hideSDL()
                        }
                        .padding(8)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .allowsHitTesting(true)
                    
                    Spacer()
                        .allowsHitTesting(false)
                }
                
                Spacer()
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    SDLGameView()
}