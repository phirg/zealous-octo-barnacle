# detecting poco lib installation


if ( NOT Poco_FIND_COMPONENTS )
    set ( Poco_NOT_FOUND_MESSAGE "The Poco package requires at least one component" )
    set ( Poco_FOUND False )
    return ( )
endif ( )

set ( _Poco_NOTFOUND_MESSAGE )

foreach ( module ${Poco_FIND_COMPONENTS} )
    message ( STATUS "looking for poco component: ${module}" )

    # TODO: find libs
    # TODO: find headers
    # TODO: check version
    # NOTE: anything else?

    if ( NOT Poco${module}_FOUND )
        if ( Poco_FIND_REQUIRED_${module} )
            set ( _Poco_NOTFOUND_MESSAGE "${_Poco_NOTFOUND_MESSAGE}Failed to find Poco component \"${module}\"\n" )
        elseif ( NOT Poco_FIND_QUIETLY )
            message ( WARNING "Failed to find Poco component \"${module}\"" )
        endif ( )
    endif ( )
endforeach ( )

if (_Poco_NOTFOUND_MESSAGE)
    set(Poco_NOT_FOUND_MESSAGE "${_Poco_NOTFOUND_MESSAGE}")
    set(Poco_FOUND False)
endif()

