#####################################################
# Install dependencies 
#####################################################

option(CAUDIO_COPY_DEPENDENCIES "Copy dependency libs to the build directory" TRUE)

macro(copy_debug INPUT)
  if (EXISTS ${CAUDIO_DEPENDENCIES_DIR}/bin/debug/${INPUT})
    	if (MINGW OR NMAKE)
      		configure_file(${CAUDIO_DEPENDENCIES_DIR}/bin/debug/${INPUT} ${CMAKE_BINARY_DIR}/bin/${INPUT} COPYONLY)
	else ()
      		configure_file(${CAUDIO_DEPENDENCIES_DIR}/bin/debug/${INPUT} ${CMAKE_BINARY_DIR}/bin/debug/${INPUT} COPYONLY)
	endif ()
  endif ()
endmacro()

macro(copy_release INPUT)
  if (EXISTS ${CAUDIO_DEPENDENCIES_DIR}/bin/release/${INPUT})
    	if (MINGW OR NMAKE)
    		configure_file(${CAUDIO_DEPENDENCIES_DIR}/bin/release/${INPUT} ${CMAKE_BINARY_DIR}/bin/${INPUT} COPYONLY)
	else ()
      		configure_file(${CAUDIO_DEPENDENCIES_DIR}/bin/release/${INPUT} ${CMAKE_BINARY_DIR}/bin/release/${INPUT} COPYONLY)
      		configure_file(${CAUDIO_DEPENDENCIES_DIR}/bin/release/${INPUT} ${CMAKE_BINARY_DIR}/bin/relwithdebinfo/${INPUT} COPYONLY)
      		configure_file(${CAUDIO_DEPENDENCIES_DIR}/bin/release/${INPUT} ${CMAKE_BINARY_DIR}/bin/minsizerel/${INPUT} COPYONLY)
	endif ()
  endif ()
endmacro ()

function(install_dll_file DEBUG_FILEPATH RELEASE_FILEPATH FILENAME)
	if (EXISTS ${DEBUG_FILEPATH}${FILENAME}_d.dll)
		install(FILES
			${DEBUG_FILEPATH}${FILENAME}_d.dll
			DESTINATION bin/debug CONFIGURATIONS Debug
		)
		install(FILES
			${RELEASE_FILEPATH}${FILENAME}.dll
			DESTINATION bin/release CONFIGURATIONS Release None ""
		)
		install(FILES
			${RELEASE_FILEPATH}${FILENAME}.dll
			DESTINATION bin/relwithdebinfo CONFIGURATIONS RelWithDebInfo
		)
		install(FILES
			${RELEASE_FILEPATH}${FILENAME}.dll
			DESTINATION bin/minsizerel CONFIGURATIONS MinSizeRel
		)
		
		configure_file(${DEBUG_FILEPATH}${FILENAME}_d.dll ${CMAKE_BINARY_DIR}/bin/debug/${FILENAME}_d.dll COPYONLY)
		configure_file(${RELEASE_FILEPATH}${FILENAME}.dll ${CMAKE_BINARY_DIR}/bin/release/${FILENAME}.dll COPYONLY)
		configure_file(${RELEASE_FILEPATH}${FILENAME}.dll ${CMAKE_BINARY_DIR}/bin/relwithdebinfo/${FILENAME}.dll COPYONLY)
		configure_file(${RELEASE_FILEPATH}${FILENAME}.dll ${CMAKE_BINARY_DIR}/bin/minsizerel/${FILENAME}.dll COPYONLY)
	endif ()
endfunction(install_dll_file)

function(install_all_targets TARGETNAME)
	if (WIN32)
		install(TARGETS ${TARGETNAME}
			BUNDLE DESTINATION "bin${CAUDIO_RELEASE_PATH}" CONFIGURATIONS Release None ""
			RUNTIME DESTINATION "bin${CAUDIO_RELEASE_PATH}" CONFIGURATIONS Release None ""
			LIBRARY DESTINATION "lib/${CAUDIO_RELEASE_PATH}" CONFIGURATIONS Release None ""
			ARCHIVE DESTINATION "lib/${CAUDIO_RELEASE_PATH}" CONFIGURATIONS Release None ""
			FRAMEWORK DESTINATION "lib/${CAUDIO_RELEASE_PATH}" CONFIGURATIONS Release None ""
		)
		install(TARGETS ${TARGETNAME}
			BUNDLE DESTINATION "bin${CAUDIO_DEBUG_PATH}" CONFIGURATIONS Debug 
			RUNTIME DESTINATION "bin${CAUDIO_DEBUG_PATH}" CONFIGURATIONS Debug 
			LIBRARY DESTINATION "lib/${CAUDIO_DEBUG_PATH}" CONFIGURATIONS Debug 
			ARCHIVE DESTINATION "lib/${CAUDIO_DEBUG_PATH}" CONFIGURATIONS Debug 
			FRAMEWORK DESTINATION "lib/${CAUDIO_DEBUG_PATH}" CONFIGURATIONS Debug 
		)
		install(TARGETS ${TARGETNAME}
			BUNDLE DESTINATION "bin/" CONFIGURATIONS RelWithDebInfo
			RUNTIME DESTINATION "bin/" CONFIGURATIONS RelWithDebInfo
			LIBRARY DESTINATION "lib/" CONFIGURATIONS RelWithDebInfo
			ARCHIVE DESTINATION "lib/" CONFIGURATIONS RelWithDebInfo
			FRAMEWORK DESTINATION "lib/" CONFIGURATIONS RelWithDebInfo
		)
		install(TARGETS ${TARGETNAME}
			BUNDLE DESTINATION "bin/MinSizeRel" CONFIGURATIONS MinSizeRel 
			RUNTIME DESTINATION "bin/MinSizeRel" CONFIGURATIONS MinSizeRel 
			LIBRARY DESTINATION "lib/MinSizeRel" CONFIGURATIONS MinSizeRel 
			ARCHIVE DESTINATION "lib/MinSizeRel" CONFIGURATIONS MinSizeRel 
			FRAMEWORK DESTINATION "lib/MinSizeRel" CONFIGURATIONS MinSizeRel 
		)
	elseif (UNIX AND NOT APPLE)
		install(TARGETS ${TARGETNAME}
                        RUNTIME DESTINATION bin 
                        LIBRARY DESTINATION lib 
                        ARCHIVE DESTINATION lib 
		)
	endif ()
endfunction(install_all_targets)

if (CAUDIO_COPY_DEPENDENCIES)
	if (WIN32)	
		copy_debug(OpenAL32.dll)
		copy_release(OpenAL32.dll)
				
		copy_debug(wrap_oal.dll)
		copy_release(wrap_oal.dll)
	endif ()
endif ()
