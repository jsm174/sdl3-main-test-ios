import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView = .splash
    @Published var isSDLActive = false
    
    enum AppView {
        case splash
        case mainMenu
        case game
    }
    
    func showSplash() {
        currentView = .splash
        isSDLActive = false
    }
    
    func showMainMenu() {
        currentView = .mainMenu
        isSDLActive = false
    }
    
    func showGame() {
        currentView = .game
        isSDLActive = true
    }
    
    func handleGameSelection(_ option: String) {
        print("Selected: \(option)")
        
        switch option {
        case "Start Game":
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showGame()
            }
        case "Settings":
            // Handle settings in future
            break
        case "High Scores":
            // Handle high scores in future
            break
        case "About":
            // Handle about in future
            break
        case "Exit":
            // Handle exit
            break
        default:
            break
        }
    }
}