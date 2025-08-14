#define SDL_MAIN_USE_CALLBACKS
#include <SDL3/SDL_main.h>
#include <SDL3/SDL.h>
#include "../include/sdl_game_library.h"
#include <stdlib.h>

typedef struct {
    SDL_Window *window;
    SDL_Renderer *renderer;
    bool running;
    float square_x;
    float square_y;
    bool orientation_changing;
    bool sdl_visible;
    bool show_back_button;
} SDLGameState;

static SDLGameState *g_game_state = NULL;
static void (*g_swift_bridge_init_callback)(void) = NULL;

// SDL3 App Callbacks - all contained in the library
SDL_AppResult SDL_AppInit(void **appstate, int argc, char **argv) {
    SDL_Log("SDL Game Library: Starting initialization...");
    
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL_Init failed: %s", SDL_GetError());
        return SDL_APP_FAILURE;
    }
    SDL_Log("SDL Game Library: Video subsystem initialized");

    g_game_state = SDL_calloc(1, sizeof(SDLGameState));
    if (!g_game_state) {
        SDL_Log("Failed to allocate game state");
        return SDL_APP_FAILURE;
    }

    // Create fullscreen SDL3 window
    g_game_state->window = SDL_CreateWindow("SDL3 Game", 0, 0, SDL_WINDOW_FULLSCREEN);
    if (!g_game_state->window) {
        SDL_Log("SDL_CreateWindow failed: %s", SDL_GetError());
        SDL_free(g_game_state);
        return SDL_APP_FAILURE;
    }
    
    // Initially hide it until game starts
    SDL_HideWindow(g_game_state->window);

    g_game_state->renderer = SDL_CreateRenderer(g_game_state->window, NULL);
    if (!g_game_state->renderer) {
        SDL_Log("SDL_CreateRenderer failed: %s", SDL_GetError());
        SDL_DestroyWindow(g_game_state->window);
        SDL_free(g_game_state);
        return SDL_APP_FAILURE;
    }

    g_game_state->running = true;
    g_game_state->square_x = 350;
    g_game_state->square_y = 250;
    g_game_state->orientation_changing = false;
    g_game_state->sdl_visible = false;
    g_game_state->show_back_button = true;
    
    *appstate = g_game_state;
    
    // Call Swift bridge initialization if set
    if (g_swift_bridge_init_callback) {
        SDL_Log("SDL Game Library: Initializing Swift bridge...");
        g_swift_bridge_init_callback();
    }
    
    SDL_Log("SDL Game Library: Initialization complete");
    return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppIterate(void *appstate) {
    SDLGameState *state = (SDLGameState *)appstate;
    
    if (!state || !state->running) {
        return SDL_APP_SUCCESS;
    }

    // Only render if SDL is visible
    if (state->sdl_visible) {
        SDL_SetRenderDrawColor(state->renderer, 64, 128, 255, 255);
        SDL_RenderClear(state->renderer);
        
        SDL_SetRenderDrawColor(state->renderer, 255, 255, 255, 255);
        SDL_FRect rect = { state->square_x, state->square_y, 100, 100 };
        SDL_RenderFillRect(state->renderer, &rect);
        
        SDL_RenderPresent(state->renderer);
    } else {
        // Simple render when not visible
        SDL_SetRenderDrawColor(state->renderer, 255, 0, 0, 255);
        SDL_RenderClear(state->renderer);
        SDL_RenderPresent(state->renderer);
    }
    
    return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event) {
    SDLGameState *state = (SDLGameState *)appstate;
    
    SDL_Log("SDL Game Library: Received event type: %d", event->type);
    
    if (event->type == SDL_EVENT_QUIT) {
        state->running = false;
        return SDL_APP_SUCCESS;
    }
    
    if (event->type == SDL_EVENT_WINDOW_RESIZED) {
        state->orientation_changing = true;
        int window_width, window_height;
        SDL_GetWindowSize(state->window, &window_width, &window_height);
        
        // Clamp square position to new window bounds
        if (state->square_x > window_width - 100) state->square_x = window_width - 100;
        if (state->square_y > window_height - 100) state->square_y = window_height - 100;
        
        state->orientation_changing = false;
    }
    
    if (event->type == SDL_EVENT_FINGER_DOWN || event->type == SDL_EVENT_FINGER_MOTION) {
        SDL_Log("SDL received finger event: %s", event->type == SDL_EVENT_FINGER_DOWN ? "DOWN" : "MOTION");
        if (state->orientation_changing || !state->sdl_visible) return SDL_APP_CONTINUE;
        
        // Use window dimensions 
        int window_width, window_height;
        SDL_GetWindowSize(state->window, &window_width, &window_height);
        
        state->square_x = event->tfinger.x * window_width - 50;
        state->square_y = event->tfinger.y * window_height - 50;
        
        if (state->square_x < 0) state->square_x = 0;
        if (state->square_y < 0) state->square_y = 0;
        if (state->square_x > window_width - 100) state->square_x = window_width - 100;
        if (state->square_y > window_height - 100) state->square_y = window_height - 100;
        
        SDL_Log("Square moved to: %f, %f", state->square_x, state->square_y);
    }
    
    // Handle touch events via mouse events (iOS translates touches to mouse events)
    if (event->type == SDL_EVENT_MOUSE_BUTTON_DOWN || event->type == SDL_EVENT_MOUSE_MOTION) {
        if (state->orientation_changing || !state->sdl_visible) return SDL_APP_CONTINUE;
        
        float touch_x, touch_y;
        
        if (event->type == SDL_EVENT_MOUSE_BUTTON_DOWN) {
            SDL_Log("SDL received mouse button down at: %f, %f", event->button.x, event->button.y);
            touch_x = event->button.x;
            touch_y = event->button.y;
        } else {
            SDL_Log("SDL received mouse motion at: %f, %f", event->motion.x, event->motion.y);
            touch_x = event->motion.x;
            touch_y = event->motion.y;
        }
        
        // Use window dimensions 
        int window_width, window_height;
        SDL_GetWindowSize(state->window, &window_width, &window_height);
        
        state->square_x = touch_x - 50;
        state->square_y = touch_y - 50;
        
        if (state->square_x < 0) state->square_x = 0;
        if (state->square_y < 0) state->square_y = 0;
        if (state->square_x > window_width - 100) state->square_x = window_width - 100;
        if (state->square_y > window_height - 100) state->square_y = window_height - 100;
        
        SDL_Log("Square moved to: %f, %f", state->square_x, state->square_y);
    }
    
    return SDL_APP_CONTINUE;
}

void SDL_AppQuit(void *appstate, SDL_AppResult result) {
    SDLGameState *state = (SDLGameState *)appstate;
    
    if (state) {
        if (state->renderer) {
            SDL_DestroyRenderer(state->renderer);
        }
        if (state->window) {
            SDL_DestroyWindow(state->window);
        }
        SDL_free(state);
    }
    
    SDL_Quit();
}

// Public API functions for Swift bridge
void sdl_game_set_visibility(bool visible) {
    if (g_game_state) {
        g_game_state->sdl_visible = visible;
        SDL_Log("SDL Game Library: Visibility set to: %s", visible ? "true" : "false");
    }
}

void sdl_game_show_window(void) {
    if (g_game_state && g_game_state->window) {
        SDL_Log("SDL Game Library: Showing window");
        SDL_ShowWindow(g_game_state->window);
    }
}

void sdl_game_hide_window(void) {
    if (g_game_state && g_game_state->window) {
        SDL_Log("SDL Game Library: Hiding window");
        SDL_HideWindow(g_game_state->window);
    }
}

void* sdl_game_get_window(void) {
    return g_game_state ? g_game_state->window : NULL;
}

void sdl_game_handle_touch(float x, float y) {
    if (g_game_state && g_game_state->sdl_visible && !g_game_state->orientation_changing) {
        int window_width, window_height;
        SDL_GetWindowSize(g_game_state->window, &window_width, &window_height);
        
        g_game_state->square_x = x - 50;
        g_game_state->square_y = y - 50;
        
        if (g_game_state->square_x < 0) g_game_state->square_x = 0;
        if (g_game_state->square_y < 0) g_game_state->square_y = 0;
        if (g_game_state->square_x > window_width - 100) g_game_state->square_x = window_width - 100;
        if (g_game_state->square_y > window_height - 100) g_game_state->square_y = window_height - 100;
        
        SDL_Log("Square moved to: %f, %f", g_game_state->square_x, g_game_state->square_y);
    }
}

void sdl_game_set_swift_bridge_callback(void (*callback)(void)) {
    g_swift_bridge_init_callback = callback;
}