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

# find python
# If you'd like to specify the installation of Python to use, you should
# modify the following cache variables:
#   PYTHON_LIBRARY             - path to the python library
#   PYTHON_INCLUDE_DIR         - path to where Python.h is found
find_package ( PythonLibs 2.7 )

if ( NOT PYTHONLIBS_FOUND ) 
    message ( WARNING "Python not found" )
# require cmake >= 2.8.8 to use PYTHONLIBS_VERSION_STRING
elseif ( NOT PYTHONLIBS_VERSION_STRING MATCHES "^2\\.7\\." )
	message ( WARNING "Python version 2.7 not found. Found: ${PYTHONLIBS_VERSION_STRING}. ")
else ( NOT PYTHONLIBS_FOUND )
    add_definitions ( -DHAVE_PYTHON27 )
    message ( STATUS "Python libraries are: ${PYTHON_LIBRARIES}" )
    message ( STATUS "Python include path is: ${PYTHON_INCLUDE_DIRS}" )
    message ( STATUS "Python full version is: ${PYTHONLIBS_VERSION_STRING}" )
    include_directories ( ${PYTHON_INCLUDE_DIRS} )
    target_link_libraries(hello ${PYTHON_LIBRARIES})
endif ( NOT PYTHONLIBS_FOUND ) 

target_link_libraries(hello Poco::Foundation Poco::Util ${PYTHON_LIBRARIES})

message ( STATUS "cmake running....")

# TESTS
enable_testing ()

# raw tests __without__ test framework
# test that the final binary is executable
add_test (
    NAME helloExec
    COMMAND $<TARGET_FILE:hello>
    )
