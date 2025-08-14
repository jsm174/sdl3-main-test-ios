import SwiftUI

struct SplashView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Full screen background
            Color.black
                .ignoresSafeArea(.all)
            
            // Content
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("SDL3 Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Powered by SDL3 & SwiftUI")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                opacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 1.0)) {
                    opacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    coordinator.showMainMenu()
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppCoordinator())
}