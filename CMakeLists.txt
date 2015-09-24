# minimalist cmake file
cmake_minimum_required (VERSION 2.8)
project (HELLO)

add_executable (hello hello.cpp)

message ( STATUS "cmake running....")

# TESTS
enable_testing ()

# raw tests __without__ test framework
# test that the final binary is executable
add_test (
    NAME helloExec
    COMMAND $<TARGET_FILE:hello>
    )
