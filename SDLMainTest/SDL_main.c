#define SDL_MAIN_USE_CALLBACKS
#include <SDL3/SDL_main.h>
#include <SDL3/SDL.h>

// Bridge functions
void setSDLRenderView(void* view);
void setSDLVisibility(bool visible);
void updateSDLViewSize(float width, float height);
void setAppState(void* appstate);

typedef struct {
    SDL_Window *window;
    SDL_Renderer *renderer;
    bool running;
    float square_x;
    float square_y;
    bool orientation_changing;
    bool sdl_visible;
    bool show_back_button;
} AppState;

SDL_AppResult SDL_AppInit(void **appstate, int argc, char **argv) {
    SDL_Log("SDL_AppInit: Starting initialization...");
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        SDL_Log("SDL_Init failed: %s", SDL_GetError());
        return SDL_APP_FAILURE;
    }
    SDL_Log("SDL_Init: Video subsystem initialized");

    AppState *state = SDL_calloc(1, sizeof(AppState));
    if (!state) {
        SDL_Log("Failed to allocate app state");
        return SDL_APP_FAILURE;
    }

    // Create fullscreen SDL3 window
    state->window = SDL_CreateWindow("SDL3 Game", 0, 0, SDL_WINDOW_FULLSCREEN);
    if (!state->window) {
        SDL_Log("SDL_CreateWindow failed: %s", SDL_GetError());
        SDL_free(state);
        return SDL_APP_FAILURE;
    }
    
    // Initially hide it until game starts
    SDL_HideWindow(state->window);

    state->renderer = SDL_CreateRenderer(state->window, NULL);
    if (!state->renderer) {
        SDL_Log("SDL_CreateRenderer failed: %s", SDL_GetError());
        SDL_DestroyWindow(state->window);
        SDL_free(state);
        return SDL_APP_FAILURE;
    }

    state->running = true;
    state->square_x = 350;
    state->square_y = 250;
    state->orientation_changing = false;
    state->sdl_visible = false;
    state->show_back_button = true;
    *appstate = state;
    
    // Set the app state for bridge communication
    SDL_Log("SDL_AppInit: Setting app state and initializing SwiftUI...");
    setAppState(state);
    
    SDL_Log("SDL_AppInit: Complete");
    return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppIterate(void *appstate) {
    AppState *state = (AppState *)appstate;
    
    if (!state->running) {
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
        // Try a simple render to see if SDL window is working
        SDL_SetRenderDrawColor(state->renderer, 255, 0, 0, 255);
        SDL_RenderClear(state->renderer);
        SDL_RenderPresent(state->renderer);
    }
    
    return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event) {
    AppState *state = (AppState *)appstate;
    
    // Log all events to see what we're receiving
    SDL_Log("SDL_AppEvent: Received event type: %d", event->type);
    
    if (event->type == SDL_EVENT_QUIT) {
        state->running = false;
        return SDL_APP_SUCCESS;
    }
    
    // Removed old keyboard shortcuts - now handled by SwiftUI overlay
    
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
    
    // Handle touch events directly - both finger and mouse (iOS can generate both)
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
    AppState *state = (AppState *)appstate;
    
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