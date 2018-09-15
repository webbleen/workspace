cmake_minimum_required(VERSION 3.6)
project(ParseWebUrl)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(HEADER_FILES WebUrl.h)
set(SOURCE_FILES WebUrl.cpp main.cpp)
add_executable(ParseWebUrl ${SOURCE_FILES})