cmake_minimum_required(VERSION 3.6)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -levent")

project(higher_client)
set(SOURCE_FILES client.c)
add_executable(higher_client ${SOURCE_FILES})

project(higher_server)
set(SOURCE_FILES server.c)
add_executable(higher_server ${SOURCE_FILES})
