#ifndef SDL_GAME_ENGINE_H
#define SDL_GAME_ENGINE_H

#include <stdbool.h>

// Simple API functions for the game engine
void sdl_game_set_visibility(bool visible);
void sdl_game_show_window(void);
void sdl_game_hide_window(void);
void* sdl_game_get_window(void);
void sdl_game_set_swift_bridge_callback(void (*callback)(void));

#endif