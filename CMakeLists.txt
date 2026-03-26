cmake_minimum_required(VERSION 3.15...4.0)
project(first_task LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "" FORCE)

add_library(REPLACE_WITH_TARGET STATIC
  ${CMAKE_SOURCE_DIR}/src/REPLACE_WITH_TARGET.cpp
)

target_include_directories(REPLACE_WITH_TARGET PUBLIC
  ${CMAKE_SOURCE_DIR}/include
)

add_executable(REPLACE_WITH_TARGET_impl
  ${CMAKE_SOURCE_DIR}/src/main.cpp
)

option(SANITIZE_ADDRESS OFF)

if(SANITIZE_ADDRESS)
    target_compile_options(REPLACE_WITH_TARGET_impl PRIVATE
        -fsanitize=address
        -fno-omit-frame-pointer
    )

    target_link_options(REPLACE_WITH_TARGET_impl PRIVATE
        -fsanitize=address
    )
endif()

target_link_libraries(REPLACE_WITH_TARGET_impl PRIVATE REPLACE_WITH_TARGET)
target_compile_options(REPLACE_WITH_TARGET_impl PRIVATE)
target_link_options(REPLACE_WITH_TARGET_impl PRIVATE)

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)
FetchContent_MakeAvailable(googletest)


enable_testing()

add_executable(
  REPLACE_WITH_TARGET_test
  ${CMAKE_SOURCE_DIR}/test/REPLACE_WITH_TARGET_test.cpp
)
target_link_libraries(
  REPLACE_WITH_TARGET_test
  GTest::gtest_main
  GTest::gmock_main
)
target_include_directories(REPLACE_WITH_TARGET_test PUBLIC
  ${CMAKE_SOURCE_DIR}/include
)

include(GoogleTest)
gtest_discover_tests(REPLACE_WITH_TARGET_test)
