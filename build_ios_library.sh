#!/bin/bash

# Build SDL Game Library for iOS directly using clang

echo "Building SDL Game Library for iOS..."

# Set up paths
SDL3_INCLUDE="/Users/jmillard/Desktop/SDL/SDLMainTest/third-party/include"
SDL3_LIB="/Users/jmillard/Desktop/SDL/SDLMainTest/third-party/build-libs/ios-arm64"
SOURCE_DIR="/Users/jmillard/Desktop/SDL/SDLMainTest/src"
OUTPUT_DIR="/Users/jmillard/Desktop/SDL/SDLMainTest"

# iOS SDK path
IOS_SDK="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"

# Compile the source to object file
echo "Compiling for iOS arm64..."
clang -c \
    -arch arm64 \
    -isysroot "$IOS_SDK" \
    -mios-version-min=12.0 \
    -I"$SDL3_INCLUDE" \
    -I"$OUTPUT_DIR/include" \
    "$SOURCE_DIR/sdl_game_engine.c" \
    -o sdl_game_engine.o

# Create static library
echo "Creating static library..."
ar rcs libSDLGameLibrary.a sdl_game_engine.o

# Copy to project directory and third-party lib directory
cp libSDLGameLibrary.a SDLMainTest/
cp libSDLGameLibrary.a third-party/build-libs/ios-arm64/

# Clean up
rm sdl_game_engine.o libSDLGameLibrary.a

echo "iOS library built successfully!"
echo "Library copied to:"
echo "- SDLMainTest/libSDLGameLibrary.a"
echo "- third-party/build-libs/ios-arm64/libSDLGameLibrary.a"