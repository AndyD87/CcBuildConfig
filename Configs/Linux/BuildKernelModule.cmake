
set(VERBOSE_OUTPUT "V=1")

if(DEFINED KERNEL_OBJECTS)
    if(EXISTS ${KERNEL_BUILD_DIR}/Kbuild.in)
        configure_file( "${KERNEL_BUILD_DIR}/Kbuild.in"
                        "${KERNEL_BUILD_DIR}/Kbuild" @ONLY)
        foreach(KERNEL_OBJECT ${KERNEL_OBJECTS})
            file(RELATIVE_PATH KERNEL_OBJECT_RELATIVE ${KERNEL_BUILD_DIR} ${KERNEL_OBJECT})
            file(APPEND ${KERNEL_BUILD_DIR}/Kbuild "  ${KERNEL_OBJECT_RELATIVE}  \\\n")
        endforeach()
        file(APPEND ${KERNEL_BUILD_DIR}/Kbuild "\n")
        execute_process(COMMAND ${CMAKE_MAKE_PROGRAM} ${VERBOSE_OUTPUT} -f ${CURRENT_PROJECT}MakeFile )
    endif()
endif()
