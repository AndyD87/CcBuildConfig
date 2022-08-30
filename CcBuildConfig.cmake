if(NOT CCBUILDCONFIG_DIR)
  set(CCBUILDCONFIG_DIR ${CMAKE_CURRENT_LIST_DIR})

  include(${CCBUILDCONFIG_DIR}/CcMacros.cmake )

  ################################################################################
  # Setup Toolchain globaly
  ################################################################################
  # Load Board settings if defined
  if(DEFINED CCOS_BOARD)
    CcGetKnownBoard(${CCOS_BOARD} BoardDir)
    if(NOT ${BoardDir} STREQUAL "")
      include(${CCBUILDCONFIG_DIR}/${BoardDir})
    elseif(${CCOS_BOARD} MATCHES "/Config.cmake")
      include(${CCBUILDCONFIG_DIR}/${CCOS_BOARD})
    else()
      include(${CCBUILDCONFIG_DIR}/${CCOS_BOARD}/Config.cmake)
    endif()
    if(CCOS_BOARD_TYPE)
      add_definitions(-DCCOS_BOARD_TYPE=${CCOS_BOARD_TYPE})
    endif()
  endif()

  ################################################################################
  # Load Conan if available
  ################################################################################
  if(EXISTS ${CCBUILDCONFIG_DIR}/Conan/conan.cmake)
    include(${CCBUILDCONFIG_DIR}/Conan/conan.cmake)
  endif()

  macro(CcBuildConfigLoad)
    ################################################################################
    # Setup Default Values for CMAKE
    ################################################################################
    CcNoConfigurationDirs()
    enable_testing()
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)

    ################################################################################
    # Include Config File if config is set or auto select
    ################################################################################
    if(DEFINED CONFIGFILE)
      include( ${CONFIGFILE} )
    else()
      # Use default System Config
      if("${CMAKE_SYSTEM_NAME}" STREQUAL "Generic" OR GENERIC)
        set(CMAKE_SYSTEM_NAME "Generic")
        message( "- Platform: Generic" )
        include( ${CCBUILDCONFIG_DIR}/Configs/Config.Generic.cmake)
      elseif(DEFINED WIN32)
        message( "- Platform: Windows" )
        include( ${CCBUILDCONFIG_DIR}/Configs/Config.Windows.cmake)
      else()
        message( "- Platform: Linux" )
        include( ${CCBUILDCONFIG_DIR}/Configs/Config.Linux.cmake)
      endif()
    endif()

    ################################################################################
    # Load includes if they are available
    ################################################################################
    if(CCOS_CMAKE_INCLUDES)
      list(REMOVE_DUPLICATES CCOS_CMAKE_INCLUDES)
      foreach(CCOS_CMAKE_INCLUDE ${CCOS_CMAKE_INCLUDES})
        include(${CCOS_CMAKE_INCLUDE})
      endforeach()
    endif()

    ################################################################################
    # Load Compiler Settings depending on Compiler Type
    ################################################################################
    if( APPLE )
      include( ${CCBUILDCONFIG_DIR}/Toolchains/Apple.cmake)
    elseif( DEFINED MSVC )
      include( ${CCBUILDCONFIG_DIR}/Toolchains/MSVC.cmake)
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
      include( ${CCBUILDCONFIG_DIR}/Toolchains/Clang.cmake)
    else( DEFINED GCC )
      set(GCC TRUE)
      include( ${CCBUILDCONFIG_DIR}/Toolchains/GCC.cmake )
    endif()

    ################################################################################
    # Enable Memory Monitor if required
    ################################################################################
    if(DEFINED MEMORYMONITOR_ENABLED)
      add_definitions(-DMEMORYMONITOR_ENABLED)
    endif(DEFINED MEMORYMONITOR_ENABLED)
  endmacro()
endif(NOT CCBUILDCONFIG_DIR)