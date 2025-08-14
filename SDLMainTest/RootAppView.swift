import SwiftUI

struct RootAppView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        switch coordinator.currentView {
        case .splash:
            SplashView()
        case .mainMenu:
            MainMenuView()
        case .game:
            GameView()
        }
    }
}

struct GameView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        // Empty view - SDL renders fullscreen, overlay is handled separately
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
    RootAppView()
        .environmentObject(AppCoordinator())
}