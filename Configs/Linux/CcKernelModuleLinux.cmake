################################################################################
#
# Prebuild-Step
#   apt-get install build-essential linux-headers-`uname -r`
# Install-Step
#   sudo insmod CcKernelModuleLinux.ko
# Uninstall-Step
#   sudo rmmod CcKernelModuleLinux.ko
################################################################################

# include build script to get it in IDE, it has no effekt here
include(${CMAKE_CURRENT_LIST_DIR}/BuildKernelModule.cmake)

# Generate relative file path for kernel link
file(RELATIVE_PATH LINUX_KERNEL_FILE_PATH ${CMAKE_CURRENT_BINARY_DIR} "${CMAKE_CURRENT_LIST_DIR}/main.c")
get_filename_component(LINUX_KERNEL_FILE_PATH ${LINUX_KERNEL_FILE_PATH} DIRECTORY)

set(SOURCE_FILES
    "${CMAKE_CURRENT_LIST_DIR}/Kbuild.in"
    "${CMAKE_CURRENT_LIST_DIR}/main.c"
    "${CMAKE_CURRENT_LIST_DIR}/CcMalloc.c"
)

configure_file( "${CMAKE_CURRENT_LIST_DIR}/Kbuild.in"
                "${CMAKE_CURRENT_BINARY_DIR}/Kbuild.in" @ONLY)
configure_file( "${CMAKE_CURRENT_LIST_DIR}/main.c"
                "${CMAKE_CURRENT_BINARY_DIR}/main.c" @ONLY)
configure_file( "${CMAKE_CURRENT_LIST_DIR}/CcMalloc.c"
                "${CMAKE_CURRENT_BINARY_DIR}/CcMalloc.c" @ONLY)

file(WRITE  ${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}MakeFile "all:\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}MakeFile "\tmake -C ${KERNELHEADERS_DIR} M=${CMAKE_CURRENT_BINARY_DIR} modules\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}MakeFile "clean:\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}MakeFile "\tmake -C ${KERNELHEADERS_DIR} M=${CMAKE_CURRENT_BINARY_DIR} clean\n")
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}MakeFile "\n")


add_custom_command( OUTPUT ${ProjectName}.ko
                    COMMAND ${CMAKE_COMMAND} -D "KERNEL_OBJECTS=\"$<TARGET_OBJECTS:CcKernelModule>;$<TARGET_OBJECTS:${ProjectName}>\""
                                             -D "KERNEL_BUILD_DIR=${CMAKE_CURRENT_BINARY_DIR}"
                                             -D "CURRENT_PROJECT=${ProjectName}"
                                             -D "CMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
                                             -P ${CMAKE_CURRENT_LIST_DIR}/BuildKernelModule.cmake
                    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}.ko ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/../drv/${ProjectName}.ko
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    COMMENT "Building kernel module..."
)

add_custom_target ( ${ProjectName}Km ALL
                    DEPENDS ${ProjectName}.ko
                    SOURCES ${SOURCE_FILES}
)

add_dependencies(${ProjectName}Km ${ProjectName})
