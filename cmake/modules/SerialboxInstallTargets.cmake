##===------------------------------------------------------------------------------*- CMake -*-===##
##
##                                   S E R I A L B O X
##
## This file is distributed under terms of BSD license. 
## See LICENSE.txt for more information.
##
##===------------------------------------------------------------------------------------------===##

#
# serialbox_install_targets( [PUBLIC] TARGETS [ target1 [ target2 ... ] )
#
#  Arguments:
#
#       TARGETS [target1 [ target2 ...] ]   Targets to be exported and installed.
#                                           Additionally the target is added to the variable
#                                               ${PROJECT_NAME}_ALL_TARGETS
#       PUBLIC (optional)                   If this option is defined, the targets are in addition
#                                           added to the variable
#                                               ${PROJECT_NAME}_PUBLIC_TARGETS
#
#  The targets stored in ${PROJECT_NAME}_PUBLIC_TARGETS will be publicly advertised during a call to
#
#      find_package( Serialbox )
#

set( ${PROJECT_NAME}_PUBLIC_TARGETS "" CACHE INTERNAL "" )
set( ${PROJECT_NAME}_ALL_TARGETS "" CACHE INTERNAL "" )
set( ${PROJECT_NAME}_NAMESPACE "Serialbox::" )

function( serialbox_install_targets )
  cmake_parse_arguments( serialbox_install_targets "PUBLIC" "" "TARGETS" ${ARGN})
  
  set(target_list ${serialbox_install_targets_TARGETS})
  set(public ${serialbox_install_targets_PUBLIC})

  foreach( target ${target_list} )
    if( TARGET ${target} )
      set( ${PROJECT_NAME}_ALL_TARGETS ${${PROJECT_NAME}_ALL_TARGETS} ${target} CACHE INTERNAL "" )
      if( public ) 
        set( ${PROJECT_NAME}_PUBLIC_TARGETS ${${PROJECT_NAME}_PUBLIC_TARGETS} ${target} CACHE INTERNAL "" )
      endif()
      install(TARGETS ${target}
        EXPORT ${PROJECT_NAME}Targets
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
      )
      export( TARGETS ${target}
        APPEND FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}Targets.cmake
        NAMESPACE ${${PROJECT_NAME}_NAMESPACE}
      )
      add_library( ${${PROJECT_NAME}_NAMESPACE}${target} ALIAS ${target} )
    endif()
  endforeach()
endfunction()
