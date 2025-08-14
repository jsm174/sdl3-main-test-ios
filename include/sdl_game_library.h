#ifndef SDL_GAME_LIBRARY_H
#define SDL_GAME_LIBRARY_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>

// Bridge functions for Swift integration
void sdl_game_set_visibility(bool visible);
void sdl_game_show_window(void);
void sdl_game_hide_window(void);
void* sdl_game_get_window(void);
void sdl_game_handle_touch(float x, float y);

// Bridge initialization - called from Swift when ready
void sdl_game_set_swift_bridge_callback(void (*callback)(void));

// The library automatically handles SDL3 app callbacks
// Just link this library and SDL3 will call our functions

#ifdef __cplusplus
}
#endif

#endif // SDL_GAME_LIBRARY_H