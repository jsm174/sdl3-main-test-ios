import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var selectedOption: String? = nil
    
    let menuOptions = [
        "Start Game",
        "Settings",
        "High Scores",
        "About"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 10) {
                Text("SDL3 Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Main Menu")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)
            
            VStack(spacing: 15) {
                ForEach(menuOptions, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                        coordinator.handleGameSelection(option)
                    }) {
                        HStack {
                            Text(option)
                                .font(.title3)
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(selectedOption == option ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedOption == option ? Color.blue : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Color.black)
    }
}

#Preview {
    MainMenuView()
        .environmentObject(AppCoordinator())
}
