#!/bin/bash

# Build script for SDL Game Library
# This script builds the library for both iOS device and simulator

echo "Building SDL Game Library..."

# Clean previous builds
rm -rf build
rm -rf lib

# Create build directory
mkdir -p build

# Build for iOS device (arm64)
echo "Building for iOS device..."
cd build
cmake .. -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0
make
cd ..

# The library is now available at lib/libSDLGameLibrary.a
# Copy files to Xcode project directory
echo "Copying library files to Xcode project..."
cp lib/libSDLGameLibrary.a SDLMainTest/
cp include/sdl_game_library.h SDLMainTest/

echo "Library built successfully!"
echo "Files copied to SDLMainTest/ directory:"
echo "- libSDLGameLibrary.a (add to Xcode project)"
echo "- sdl_game_library.h (add to Xcode project)"
echo ""
echo "In Xcode:"
echo "1. Add libSDLGameLibrary.a to your project"
echo "2. Add sdl_game_library.h to your project"
echo "3. The library will automatically handle SDL3 app callbacks"