# SDL3 + SwiftUI Integration Test

A test project exploring integration between SDL3 and SwiftUI on iOS, built to evaluate SDL3's new [main callbacks system](https://wiki.libsdl.org/SDL3/README-main-functions).

## Background

This project was created to research potential SDL3+SwiftUI integration for Visual Pinball. The main challenge was determining if SDL3's new callback-based lifecycle could work alongside SwiftUI's navigation system.

## What It Demonstrates

- SDL3 app callbacks (`SDL_AppInit`, `SDL_AppIterate`, `SDL_AppEvent`, `SDL_AppQuit`)
- SwiftUI navigation with SDL3 fullscreen rendering
- Touch event coordination between both systems
- Static library encapsulation of SDL3 code

## Architecture

- **`src/sdl_game_engine.c`** - SDL3 game engine with app callbacks
- **`include/sdl_game_library.h`** - C API for Swift integration
- **`SDLMainTest/`** - SwiftUI app with bridge to SDL3 library
- **`build_library.sh`** - Script to compile the SDL3 library for iOS

## Building

```bash
./build_library.sh
open SDLMainTest.xcodeproj
```

## Results

Successfully demonstrates that SDL3's callback system can work with SwiftUI navigation, with proper touch event handling between the two systems.

---

*Generated entirely by Claude. See [CLAUDE.md](CLAUDE.md) for detailed technical journey.*
