# Download the latest CcOS Release
if(NOT EXISTS ${CMAKE_CURRENT_LIST_DIR}/CcOS)
  CcGitClone(${CMAKE_CURRENT_LIST_DIR}/CcOS "https://coolcow.de/projects/CcOS.git")
endif()

add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/CcOS/Sources)

foreach(comp ${CcOS_FIND_COMPONENTS})
  if(NOT TARGET CcOS::${comp})
    add_library(CcOS::${comp} ALIAS ${comp})
  endif()
endforeach()