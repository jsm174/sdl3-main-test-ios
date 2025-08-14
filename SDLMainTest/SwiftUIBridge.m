#import <Foundation/Foundation.h>
#import "SDLMainTest-Swift.h"
#include <SDL3/SDL.h>

static void* g_appstate = NULL;

// No longer needed - SDL renders fullscreen

void setSDLVisibility(bool visible) {
    NSLog(@"SwiftUIBridge: setSDLVisibility called with visible: %s", visible ? "true" : "false");
    if (g_appstate) {
        typedef struct {
            void *window;
            void *renderer;
            bool running;
            float square_x;
            float square_y;
            bool orientation_changing;
            bool sdl_visible;
        } AppState;
        
        AppState *state = (AppState *)g_appstate;
        state->sdl_visible = visible;
        NSLog(@"SwiftUIBridge: SDL visibility set to: %s", visible ? "true" : "false");
    } else {
        NSLog(@"SwiftUIBridge: No app state available for visibility");
    }
}

// No longer needed - SDL handles fullscreen window

void showSDLWindowFromC(void) {
    NSLog(@"SwiftUIBridge: showSDLWindowFromC called");
    if (g_appstate) {
        typedef struct {
            void *window;
            void *renderer;
            bool running;
            float square_x;
            float square_y;
            bool orientation_changing;
            bool sdl_visible;
            bool show_back_button;
        } AppState;
        
        AppState *state = (AppState *)g_appstate;
        NSLog(@"SwiftUIBridge: Showing SDL window: %p", state->window);
        SDL_ShowWindow((SDL_Window*)state->window);
        
        // Add SwiftUI overlay to SDL window's view controller
        [[SDLBridge shared] addOverlayToSDLWindow:(SDL_Window*)state->window];
    } else {
        NSLog(@"SwiftUIBridge: No app state available for showSDLWindow");
    }
}

void hideSDLWindowFromC(void) {
    if (g_appstate) {
        typedef struct {
            void *window;
            void *renderer;
            bool running;
            float square_x;
            float square_y;
            bool orientation_changing;
            bool sdl_visible;
            bool show_back_button;
        } AppState;
        
        AppState *state = (AppState *)g_appstate;
        SDL_HideWindow((SDL_Window*)state->window);
        
        // Remove SwiftUI overlay from SDL window
        [[SDLBridge shared] removeOverlayFromSDLWindow];
    }
}

void setAppState(void* appstate) {
    g_appstate = appstate;
    
    // Initialize the SwiftUI app when SDL is ready
    NSLog(@"SDL: Initializing SwiftUI app...");
    [[SDLBridge shared] initializeApp];
}