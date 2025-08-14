#import <Foundation/Foundation.h>
#import "SDLMainTest-Swift.h"
#include <SDL3/SDL.h>
#include <SDL3/SDL_video.h>
#include "sdl_game_library.h"

void setSDLVisibility(bool visible) {
    sdl_game_set_visibility(visible);
}

void showSDLWindowFromC(void) {
    sdl_game_show_window();
    void *window = sdl_game_get_window();
    if (window) {
        [[SDLBridge shared] addOverlayToSDLWindow:(SDL_Window*)window];
    }
}

void hideSDLWindowFromC(void) {
    sdl_game_hide_window();
    [[SDLBridge shared] removeOverlayFromSDLWindow];
}

void swift_bridge_init_callback(void) {
    [[SDLBridge shared] initializeApp];
}

void setAppState(void* appstate) {
    sdl_game_set_swift_bridge_callback(swift_bridge_init_callback);
}

__attribute__((constructor))
void auto_init_bridge(void) {
    sdl_game_set_swift_bridge_callback(swift_bridge_init_callback);
}