set(LINUX           TRUE)
add_definitions(-DLINUX)

find_package(KernelHeaders)
if(KERNELHEADERS_FOUND)
  message("-- LinuxHeaders available")

  set(CCKERNEL_DIR        $<TARGET_PROPERTY:CcKernel,INCLUDE_DIRECTORIES>)
  set(CCKERNEL_MODULE_AVAILABLE     TRUE)
  set(CCKERNEL_MODULE_INCLUDE_DIRS  ${CMAKE_CURRENT_LIST_DIR}/Linux)

  macro(CcAddDriverLibraryOverride ProjectName Sources)
      set(CMAKE_DEBUG_POSTFIX "")
      set(AddDriver_SOURCES ${Sources})
      foreach(_src ${ARGN})
        CcListAppendOnce(AddDriver_SOURCES "${_src}")
      endforeach()

      set(CMAKE_POSITION_INDEPENDENT_CODE FALSE)
      include_directories(${KERNELHEADERS_INCLUDE_DIRS})
      CcAddLibrary( ${ProjectName} OBJECT ${AddDriver_SOURCES})

      set(C_COMPILE_FLAGS     "-fno-builtin"
                              "-nostdlib"
                              "-nodefaultlibs"
                              "-fno-exceptions"
                              "-fno-pie"
                              "-fno-pic"
                              "-mcmodel=kernel"
                              "-fno-rtti"
                              "-std=c++11"
                              "-ffunction-sections"
                              "-fdata-sections"
      )
      set_target_properties(${ProjectName} PROPERTIES COMPILE_OPTIONS "${C_COMPILE_FLAGS}")
  endmacro()

  function(CcAddDriverOverride ProjectName Sources)
      set(AddDriver_SOURCES ${Sources})
      foreach(_src ${ARGN})
        CcListAppendOnce(AddDriver_SOURCES "${_src}")
      endforeach()
      CcAddDriverLibraryOverride(${ProjectName} ${AddDriver_SOURCES})

      include(${CCKERNEL_MODULE_INCLUDE_DIRS}/CcKernelModuleLinux.cmake)
  endfunction()

endif(KERNELHEADERS_FOUND)
