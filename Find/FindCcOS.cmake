# Download the latest CcOS Release
if(THIRDPARTY_DIR)
  set(CACHE_CCOS_DIR ${THIRDPARTY_DIR}/CcOS)
else()
  set(CACHE_CCOS_DIR ${CMAKE_CURRENT_LIST_DIR}/CcOS)
endif()

if(NOT EXISTS ${CACHE_CCOS_DIR})
  CcGitClone(${CACHE_CCOS_DIR} "https://coolcow.de/projects/CcOS.git")
endif()

add_subdirectory(${CACHE_CCOS_DIR}/Sources)

foreach(comp ${CcOS_FIND_COMPONENTS})
  if(NOT TARGET CcOS::${comp})
    if(TARGET ${comp})
        add_library(CcOS::${comp} ALIAS ${comp})
    endif()
  endif()
endforeach()
