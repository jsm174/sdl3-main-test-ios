cmake_minimum_required(VERSION 3.20)

set(PLATFORM "ios" CACHE STRING "Platform")
set(ARCH "arm64" CACHE STRING "Arch")

# iOS Platform Configuration
set(PLATFORM "ios" CACHE STRING "Platform to build for")
if(PLATFORM STREQUAL "ios" OR PLATFORM STREQUAL "ios-simulator")
 set(CMAKE_SYSTEM_NAME iOS)
 if (PLATFORM STREQUAL "ios-simulator")
   set(CMAKE_OSX_SYSROOT iphonesimulator)
 endif()
 set(CMAKE_OSX_DEPLOYMENT_TARGET 12.0)
endif()

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)

project(SDLGameLibrary)

# Find SDL3 in the third-party directory
set(SDL3_DIR "${CMAKE_CURRENT_SOURCE_DIR}/third-party")

# Always use iOS arm64 for now
set(SDL3_LIB_DIR "${SDL3_DIR}/build-libs/ios-arm64")

# Directly specify library paths instead of using find_library for iOS
set(SDL3_LIBRARY "${SDL3_LIB_DIR}/libSDL3.a")
set(SDL3_IMAGE_LIBRARY "${SDL3_LIB_DIR}/libSDL3_image.a")
set(SDL3_TTF_LIBRARY "${SDL3_LIB_DIR}/libSDL3_ttf.a")

# Verify libraries exist
if(NOT EXISTS "${SDL3_LIBRARY}")
    message(FATAL_ERROR "SDL3 library not found at ${SDL3_LIBRARY}")
endif()

# Include directories
include_directories("${SDL3_DIR}/include")

# Source files for the library
set(LIBRARY_SOURCES
    src/sdl_game_engine.c
)

# Create the static library
add_library(SDLGameLibrary STATIC ${LIBRARY_SOURCES})

# Link SDL3 libraries
target_link_libraries(SDLGameLibrary 
    ${SDL3_LIBRARY}
    ${SDL3_IMAGE_LIBRARY}
    ${SDL3_TTF_LIBRARY}
)

# Set library properties
set_target_properties(SDLGameLibrary PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/lib"
)

# Create include directory for headers
file(MAKE_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include")

# Configure for iOS
if(PLATFORM STREQUAL "ios" OR PLATFORM STREQUAL "ios-simulator")
    set_target_properties(SDLGameLibrary PROPERTIES
        OSX_ARCHITECTURES "arm64"
        XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "12.0"
    )
endif()
