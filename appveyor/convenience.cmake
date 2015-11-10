# convenience script to achieve some "simple" tasks

set ( POCO_INSTALL_DEST CACHE PATH "Poco installation directory" )

# mv ConfigPoco.cmake etc to the right place
file ( GLOB_RECURSE 

file ( COPY "${POCO_INSTALL_DEST}/lib/cmake/Poco/"
       DESTINATION "${CMAKE_ROOT}/Modules" ) 
