# minimalist cmake file
cmake_minimum_required (VERSION 2.8)
project (HELLO)

# set search path for project specific cmake modules
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

find_package( Poco 1.3.6 COMPONENTS Foundation Util REQUIRED )

if ( NOT Poco_FOUND )
    message ( WARNING "Poco not found")
else ( NOT Poco_FOUND )
    message ( STATUS "found Poco version: ${Poco_VERSION}" )
    message ( STATUS "libraries are: ${Poco_LIBRARIES}" ) 
endif ( NOT Poco_FOUND )
    
if ( NOT PocoFoundation_FOUND )
    message (WARNING "Poco foundation not found")
endif ( NOT PocoFoundation_FOUND )

if ( NOT PocoUtil_FOUND )
    message (WARNING "Poco util not found")
endif ( NOT PocoUtil_FOUND )


if ( Poco_VERSION VERSION_GREATER "1.4.0" )
	add_definitions ( -DPOCO_VERSION_H )
endif ( )

add_executable (hello hello.cpp)

target_link_libraries(hello Poco::Foundation Poco::Util)

message ( STATUS "cmake running....")

# TESTS
enable_testing ()

# raw tests __without__ test framework
# test that the final binary is executable
add_test (
    NAME helloExec
    COMMAND $<TARGET_FILE:hello>
    )
