import SwiftUI

struct GameOverlayView: View {
    let coordinator: AppCoordinator
    
    var body: some View {
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
