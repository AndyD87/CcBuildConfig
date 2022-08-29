set(LINUX           TRUE)
add_definitions(-DLINUX)

find_package(KernelHeaders)
if(KERNELHEADERS_FOUND)
  message("-- LinuxHeaders available")

  set(CCKERNEL_DIR        $<TARGET_PROPERTY:CcKernel,INCLUDE_DIRECTORIES>)
  set(CCKERNEL_MODULE_AVAILABLE     TRUE)
  set(CCKERNEL_MODULE_INCLUDE_DIRS  ${CMAKE_CURRENT_LIST_DIR}/Linux)

  function(CcAddDriverOverride ProjectName Sources)
    CcAddDriverLibraryOverride( ${ProjectName} ${AddDriver_SOURCES})

    include(${CCKERNEL_MODULE_INCLUDE_DIRS}/CcKernelModuleLinux.cmake)
  endfunction()

  macro(CcAddDriverLibraryOverride ProjectName Sources)
    set(CMAKE_DEBUG_POSTFIX "")
    set(AddDriver_SOURCES ${Sources})
    foreach(_src ${ARGN})
      CcListAppendOnce(AddDriver_SOURCES "${_src}")
    endforeach()

    set(CMAKE_POSITION_INDEPENDENT_CODE FALSE)
    CcSetCCompilerFlags("-fno-builtin -nostdlib -fno-exceptions -fno-pie -mcmodel=kernel")
    CcSetCxxCompilerFlags("-std=c++11 -fno-builtin -nostdlib -fno-rtti -fno-exceptions -fno-pie -mcmodel=kernel")
    include_directories(${KERNELHEADERS_INCLUDE_DIRS})
    CcAddLibrary( ${ProjectName} STATIC ${AddDriver_SOURCES})
  endmacro()
endif(KERNELHEADERS_FOUND)
