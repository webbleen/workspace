cmake_minimum_required(VERSION 3.6)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -levent")

project(primary_client)
set(SOURCE_FILES client.c)
add_executable(primary_client ${SOURCE_FILES})

project(primary_server)
set(SOURCE_FILES server.c)
add_executable(primary_server ${SOURCE_FILES})
