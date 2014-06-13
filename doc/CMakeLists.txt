# find required programs
find_program(HELP2MAN "help2man")
find_program(TEXI2DVI "texi2dvi")
find_program(MAKEINFO "makeinfo")

# utilities
macro (TODAY RESULT)
    if(UNIX)
        execute_process(COMMAND "date" "+%d %B %Y" OUTPUT_VARIABLE ${RESULT})
    else ()
        message(SEND_ERROR "date not implemented")
        set(${RESULT} "unknown")
    endif ()
endmacro (TODAY)

macro (TODAY_MONTH RESULT)
    if(UNIX)
        execute_process(COMMAND "date" "+%B %Y" OUTPUT_VARIABLE ${RESULT})
    else ()
        message(SEND_ERROR "date not implemented")
        set(${RESULT} "unknown")
    endif ()
endmacro (TODAY_MONTH)

TODAY(UPDATED)
TODAY_MONTH(UPDATED_MONTH)

# build texinfo manuals
configure_file(version.texi.cmake ${CMAKE_CURRENT_BINARY_DIR}/version.texi)

add_custom_target("flex.pdf" ALL
	COMMAND ${TEXI2DVI} --pdf --batch --build-dir="flex.t2p" -o "flex.pdf" "${CMAKE_CURRENT_SOURCE_DIR}/flex.texi"
)

add_custom_target("flex.info" ALL
	COMMAND ${MAKEINFO} -o "flex.info" "${CMAKE_CURRENT_SOURCE_DIR}/flex.texi"
)


# build manual page
add_custom_target("flex.1" ALL
	COMMAND ${HELP2MAN} --name="${FLEX_PACKAGE_NAME}" --section=1 $<TARGET_FILE:flex> > "flex.1"
	DEPENDS flex
)

# install
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/flex.1
	DESTINATION "share/man/man1")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/flex.pdf
	DESTINATION "share/doc/flex")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/flex.info
		${CMAKE_CURRENT_BINARY_DIR}/flex.info-1
		${CMAKE_CURRENT_BINARY_DIR}/flex.info-2
	DESTINATION "share/info")