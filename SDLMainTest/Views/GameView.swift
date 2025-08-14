import SwiftUI

struct GameView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        Color.clear
            .ignoresSafeArea()
            .onAppear {
                SDLBridge.shared.setSDLActive(true)
                SDLBridge.shared.showSDLWindow()
            }
            .onDisappear {
                SDLBridge.shared.setSDLActive(false)
                SDLBridge.shared.hideSDLWindow()
            }
    }
}

#Preview {
    GameView()
        .environmentObject(AppCoordinator())
}