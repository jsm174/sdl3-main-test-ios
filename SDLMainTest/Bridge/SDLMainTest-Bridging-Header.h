#ifndef SDLMainTest_Bridging_Header_h
#define SDLMainTest_Bridging_Header_h

#include <SDL3/SDL.h>
#include <SDL3/SDL_video.h>
#include "sdl_game_library.h"

@class SDLBridge;
void setSDLVisibility(bool visible);
void showSDLWindowFromC(void);
void hideSDLWindowFromC(void);

#endif