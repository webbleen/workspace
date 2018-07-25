cmake_minimum_required(VERSION 3.6)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -levent")

project(middle_client)
set(SOURCE_FILES client.c)
add_executable(middle_client ${SOURCE_FILES})

project(middle_server)
set(SOURCE_FILES server.c)
add_executable(middle_server ${SOURCE_FILES})
