//
//  SDLMainTestApp.swift
//  SDLMainTest
//
//  Created by Jason Millard on 7/3/25.
//

import SwiftUI
import UIKit

class AppFlowManager: ObservableObject {
    @Published var currentView: AppView = .splash
    
    enum AppView {
        case splash
        case mainMenu
        case sdlGame
    }
    
    func showMainMenu() {
        currentView = .mainMenu
    }
    
    func showSDLGame() {
        currentView = .sdlGame
    }
    
    func showSplash() {
        currentView = .splash
    }
}

class SwiftUIManager: NSObject {
    private var hostingController: UIHostingController<AnyView>?
    private var window: UIWindow?
    private let appFlowManager = AppFlowManager()
    
    func initializeApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let rootView = AnyView(RootView().environmentObject(appFlowManager))
        hostingController = UIHostingController(rootView: rootView)
        hostingController?.view.backgroundColor = UIColor.black
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = UIColor.black
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
    }
    
    func showSDLGame() {
        DispatchQueue.main.async {
            self.appFlowManager.showSDLGame()
            // Hide the main SwiftUI window and show overlay
            self.window?.isHidden = true
            self.showOverlay()
        }
    }
    
    func hideSDLGame() {
        DispatchQueue.main.async {
            self.appFlowManager.showMainMenu()
            // Hide overlay and show main window
            self.hideOverlay()
            self.window?.isHidden = false
            self.window?.makeKeyAndVisible()
        }
    }
    
    private var overlayWindow: UIWindow?
    
    func showOverlay() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let gameView = SDLGameView()
        let overlayController = UIHostingController(rootView: gameView)
        overlayController.view.backgroundColor = UIColor.clear
        
        overlayWindow = UIWindow(windowScene: windowScene)
        overlayWindow?.backgroundColor = UIColor.clear
        overlayWindow?.windowLevel = UIWindow.Level.alert
        overlayWindow?.rootViewController = overlayController
        overlayWindow?.makeKeyAndVisible()
    }
    
    func hideOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }
}

struct RootView: View {
    @EnvironmentObject var appFlow: AppFlowManager
    
    var body: some View {
        switch appFlow.currentView {
        case .splash:
            SplashView()
        case .mainMenu:
            MainMenuView()
        case .sdlGame:
            SDLGameView()
        }
    }
}

@objc class SDLSwiftUIBridge: NSObject {
    @objc static let shared = SDLSwiftUIBridge()
    private let swiftUIManager = SwiftUIManager()
    private var isSDLInitialized = false
    
    @objc func initializeApp() {
        DispatchQueue.main.async {
            self.swiftUIManager.initializeApp()
        }
    }
    
    @objc func initializeSDL() {
        if !isSDLInitialized {
            isSDLInitialized = true
        }
    }
    
    @objc func showSDL() {
        DispatchQueue.main.async {
            self.swiftUIManager.showSDLGame()
            setSDLVisibility(true)
        }
    }
    
    @objc func hideSDL() {
        DispatchQueue.main.async {
            self.swiftUIManager.hideSDLGame()
            setSDLVisibility(false)
        }
    }
    
    @objc func showSwiftUI() {
        DispatchQueue.main.async {
            self.swiftUIManager.showOverlay()
        }
    }
    
    @objc func hideSwiftUI() {
        // This will be handled by the overlay itself
    }
}
