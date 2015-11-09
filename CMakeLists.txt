# minimalist cmake file
cmake_minimum_required (VERSION 2.8)
project (HELLO)

# set search path for project specific cmake modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

# find_package(Poco 1.3.6 COMPONENTS Foundation Util REQUIRED)
find_package(Poco 1.3.6 COMPONENTS Foundation Util)

if ( NOT Poco_FOUND )
    message ( WARNING "Poco not found")
else ( NOT Poco_FOUND )
    message ( STATUS "found Poco version: ${Poco_VERSION}" )
    message ( STATUS "includes are: ${Poco_INCLUDES} or ${Poco_INCLUDE_DIRS} or ${Poco_INCLUDE_DIRECTORIES}" )
    message ( STATUS "libraries are: ${Poco_LIBRARIES}" ) 
endif ( NOT Poco_FOUND )
    
if ( NOT Foundation_FOUND )
    message (WARNING "Poco foundation not found")
endif ( NOT Foundation_FOUND )

if ( NOT Util_FOUND )
    message (WARNING "Poco util not found")
endif ( NOT Util_FOUND )

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
