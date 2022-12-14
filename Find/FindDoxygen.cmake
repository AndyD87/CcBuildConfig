
if(WIN32)
  if(EXISTS "C:/Program Files/doxygen/bin/doxygen.exe")
    set(Doxygen_FOUND       TRUE)
    set(Doxygen_EXECUTABLE  "C:/Program Files/doxygen/bin/doxygen.exe")
  elseif(EXISTS "C:/Program Files (x86)/doxygen/bin/doxygen.exe")
    set(Doxygen_FOUND       TRUE)
    set(Doxygen_EXECUTABLE  "C:/Program Files (x86)/doxygen/bin/doxygen.exe")
  elseif(EXISTS "doxygen.exe")
    set(Doxygen_FOUND       TRUE)
    set(Doxygen_EXECUTABLE  "doxygen.exe")
  elseif(EXISTS "${CMAKE_CURRENT_LISTS_DIR}/doxygen.exe")
    set(Doxygen_FOUND       TRUE)
    set(Doxygen_EXECUTABLE  "${CMAKE_CURRENT_LISTS_DIR}/doxygen.exe")
  elseif(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/doxygen.exe")
    set(Doxygen_FOUND       TRUE)
    set(Doxygen_EXECUTABLE  "${CMAKE_CURRENT_BINARY_DIR}/doxygen.exe")
  else()
    set( DOXYGEN_VERSION   "1.9.3" )
    set( DOXYGEN_DIR       "${CC_CACHE_DIR}/Tools/doxygen/${DOXYGEN_VERSION}" )
    CcDownloadAndExtract( "doxygen"
                          "${DOXYGEN_DIR}"
                          "https://coolcow.de/projects/ThirdParty/doxygen/binaries/${DOXYGEN_VERSION}.0/doxygen-${DOXYGEN_VERSION}.windows.x64.bin.zip"
                          SHA1 "8d0149f4e97c3582b70bf439eb88ddaebecf0747"
    )
    set(Doxygen_EXECUTABLE ${DOXYGEN_DIR}/doxygen.exe)
    set(Doxygen_FOUND   TRUE)
  endif()
else()
  find_program(Doxygen doxygen)
  if(Doxygen)
    set(Doxygen_FOUND   TRUE)
    set(Doxygen_EXECUTABLE  "doxygen")
  endif()
endif()
