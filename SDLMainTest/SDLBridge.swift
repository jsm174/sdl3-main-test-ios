import UIKit
import Foundation
import SwiftUI

// MARK: - SDL Bridge

@objc class SDLBridge: NSObject {
    @objc static let shared = SDLBridge()
    
    private weak var renderView: UIView?
    private var isActive = false
    private var appCoordinator: AppCoordinator?
    private var mainWindow: UIWindow?
    private var overlayWindow: UIWindow?
    
    override init() {
        super.init()
    }
    
    @objc func initializeApp() {
        print("SDLBridge: initializeApp called")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("SDLBridge: On main queue, setting up SwiftUI...")
            // This will be called from C when SDL is ready
            // Start the SwiftUI app flow
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                print("SDLBridge: Found window scene, creating coordinator...")
                let coordinator = AppCoordinator()
                self.appCoordinator = coordinator
                
                let rootView = RootAppView().environmentObject(coordinator)
                let hostingController = UIHostingController(rootView: rootView)
                
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = hostingController
                window.backgroundColor = UIColor.black
                window.windowLevel = UIWindow.Level.normal
                window.makeKeyAndVisible()
                self.mainWindow = window
                print("SDLBridge: SwiftUI window created and made visible")
            } else {
                print("SDLBridge: ERROR - No window scene found!")
                // Try again in a bit
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.initializeApp()
                }
            }
        }
    }
    
    // No longer needed - SDL renders fullscreen
    
    @objc func setSDLActive(_ active: Bool) {
        print("SDLBridge: Setting SDL active: \(active)")
        isActive = active
        setSDLVisibility(active)
    }
    
    // No longer needed - SDL handles fullscreen window
    
    @objc func getIsActive() -> Bool {
        return isActive
    }
    
    @objc func showSDLWindow() {
        showSDLWindowFromC()
        // Overlay is now added directly to SDL window's view controller
    }
    
    @objc func hideSDLWindow() {
        hideSDLWindowFromC()
        // Overlay is now removed directly from SDL window's view controller
    }
    
    private var overlayController: UIHostingController<GameOverlayView>?
    
    @objc func addOverlayToSDLWindow(_ sdlWindow: OpaquePointer) {
        guard let appCoordinator = appCoordinator else { return }
        
        // Add SwiftUI overlay to the SDL window as a child view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        guard let rootVC = keyWindow.rootViewController else { return }
        
        // Create SwiftUI overlay
        let overlayView = GameOverlayView(coordinator: appCoordinator)
        let overlayVC = UIHostingController(rootView: overlayView)
        overlayVC.view.backgroundColor = UIColor.clear
        overlayVC.view.isUserInteractionEnabled = true
        
        // Add as child view controller to SDL window
        rootVC.addChild(overlayVC)
        rootVC.view.addSubview(overlayVC.view)
        overlayVC.didMove(toParent: rootVC)
        
        // Set constraints to fill the screen
        overlayVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayVC.view.topAnchor.constraint(equalTo: rootVC.view.topAnchor),
            overlayVC.view.leadingAnchor.constraint(equalTo: rootVC.view.leadingAnchor),
            overlayVC.view.trailingAnchor.constraint(equalTo: rootVC.view.trailingAnchor),
            overlayVC.view.bottomAnchor.constraint(equalTo: rootVC.view.bottomAnchor)
        ])
        
        self.overlayController = overlayVC
    }
    
    @objc func removeOverlayFromSDLWindow() {
        overlayController?.willMove(toParent: nil)
        overlayController?.view.removeFromSuperview()
        overlayController?.removeFromParent()
        overlayController = nil
    }
}