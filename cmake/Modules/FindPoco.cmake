# detecting poco lib installation
# 
# you can set poco_include_dir and poco_lib_dir (windows) to help the
# search of the include directory and .lib files
# unable to check the version for poco not supporting cmake. 

set(_Poco_FIND_PARTS_REQUIRED)
if (Poco_FIND_REQUIRED)
    set(_Poco_FIND_PARTS_REQUIRED REQUIRED)
endif()
set(_Poco_FIND_PARTS_QUIET)
if (Poco_FIND_QUIETLY)
    set(_Poco_FIND_PARTS_QUIET QUIET)
endif()

# avoiding recursion
set ( __store CMAKE_MODULE_PATH )
unset ( CMAKE_MODULE_PATH ) 

find_package ( Poco 
    COMPONENTS
    ${Poco_FIND_COMPONENTS}
    QUIET
)

set ( CMAKE_MODULE_PATH __store )
unset ( __store )

if ( Poco_FOUND )
    message ( STATUS "Poco found automatically" )
	return ( )
endif ( )

# if not found, doing it "manually"

if ( NOT Poco_FIND_COMPONENTS )
    message ( STATUS "Poco: no component specified. Default is: Foundation" )
    set ( _poco_components "Foundation")
elseif ( )
    set ( _poco_components ${Poco_FIND_COMPONENTS} )
endif ( )

set ( _Poco_NOTFOUND_MESSAGE "" )

# looking for general paths

# safety measure. find_file and find_library write results in CACHE!
unset (_poco_include_root CACHE)

# variables to be found in cache
set (
  poco_include_dir ""
  CACHE PATH
  "Poco lib header root directory"
  )

# directories containing the .lib files for windows
if (WIN32)
    set (
      poco_lib_dir ""
      CACHE PATH
      "Poco .lib files directory"
      )
endif (WIN32)

# verify that some header files are in it
find_path ( 
    _poco_include_root
    Poco/Poco.h
    ${poco_include_dir} )

if ( _poco_include_root STREQUAL "_poco_include_root-NOTFOUND" )
    message (
        SEND_ERROR 
        "Can not find poco header files. Please check poco_include_dir variable"
        ) 
else ( _poco_include_root STREQUAL "_poco_include_root-NOTFOUND" )
    message ( STATUS "Poco/Poco.h found at ${_poco_include_root}" )
#    if ( ( NOT poco_include_dir ) OR ( check_poco_include_root STREQUAL poco_include_dir ) )
#        include_directories (${check_poco_include_root})
#        set ( Poco_INCLUDE_DIRS "${check_poco_include_root}" )
#    endif ( )
endif ( _poco_include_root STREQUAL "_poco_include_root-NOTFOUND" )


foreach ( module ${Poco_FIND_COMPONENTS} )
    message ( STATUS "Looking for poco component: ${module}" )

	unset (_poco_lib CACHE)
	find_library (_poco_lib "Poco${module}" ${poco_lib_dir})
	if (_poco_lib STREQUAL "_poco_lib-NOTFOUND")
        if ( Poco_FIND_REQUIRED_${module} )
            set ( _Poco_NOTFOUND_MESSAGE "${_Poco_NOTFOUND_MESSAGE}Failed to find Poco component \"${module}\"\n" )
        elseif ( NOT Poco_FIND_QUIETLY )
            message ( WARNING "Failed to find Poco component \"${module}\"" )
        endif ( )
	else (_poco_lib STREQUAL "_poco_lib-NOTFOUND")
		message ( 
		    STATUS
		    "Poco${module} lib found: ${_poco_lib}"
		    )

		# Create imported target Poco::${module}
		add_library ( Poco::${module} UNKNOWN IMPORTED )
	
		set_target_properties ( Poco::${module} PROPERTIES
		  INTERFACE_INCLUDE_DIRECTORIES "${_poco_include_root}/Poco/${module}"
		  IMPORTED_LOCATION "${_poco_lib}"
		)
	
#		# Import target "Poco::${module}" 
#		set_property(TARGET Poco::${module} PROPERTIES
#		  INTERFACE_INCLUDE_DIRECTORIES "${_poco_include_root}/${module}"
#		  IMPORTED_LOCATION "${_poco_lib}"
#	    )

		# NOTE: anything else to do?

	    set ( Poco${module}_FOUND True )

	endif (_poco_lib STREQUAL "_poco_lib-NOTFOUND")
endforeach ( module ${Poco_FIND_COMPONENTS} )

unset ( _poco_lib CACHE )
unset ( _poco_include_root )

if ( _Poco_NOTFOUND_MESSAGE )
    set(Poco_NOT_FOUND_MESSAGE "${_Poco_NOTFOUND_MESSAGE}")
    set(Poco_FOUND False)
else ( _Poco_NOTFOUND_MESSAGE ) 
    set(Poco_FOUND True)
endif ( _Poco_NOTFOUND_MESSAGE )

