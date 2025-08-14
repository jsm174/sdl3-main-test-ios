import SwiftUI

// MARK: - Game Overlay View

struct GameOverlayView: View {
    let coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            // Transparent background that allows touches to pass through to SDL
            Color.clear
                .allowsHitTesting(false)
            
            // Game controls positioned in center of screen
            gameControlsView
        }
    }
    
    // MARK: - Game Controls
    
    private var gameControlsView: some View {
        VStack(alignment: .center, spacing: 10) {
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
                coordinator.showMainMenu()
            }
            .padding(8)
            .background(Color.red.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .blockingTouchesUnderneath()
    }
}

#Preview {
    GameOverlayView(coordinator: AppCoordinator())
}