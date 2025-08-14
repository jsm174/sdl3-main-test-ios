#ifndef SDLMainTest_Bridging_Header_h
#define SDLMainTest_Bridging_Header_h

#define SDL_MAIN_USE_CALLBACKS
#include <SDL3/SDL_main.h>
#include <SDL3/SDL.h>

@class SDLBridge;
void setSDLVisibility(bool visible);
void showSDLWindowFromC(void);
void hideSDLWindowFromC(void);

#endif