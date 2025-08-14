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

#Preview {
    RootAppView()
        .environmentObject(AppCoordinator())
}