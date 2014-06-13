add_custom_command(
    OUTPUT scanner.c
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l
    COMMAND ${SHELL}
    ARGS -c "${TEST_ENV_VARS} $<TARGET_FILE:flex> ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l"
)

add_executable(test-charset-r
    scanner.c
)

add_test(
    NAME test-charset-r-ascii
    COMMAND ${SHELL} -c "./test-charset-r ASCII < ${CMAKE_CURRENT_SOURCE_DIR}/test-ascii.input | diff - ${CMAKE_CURRENT_SOURCE_DIR}/test-ascii.output"
)
add_test(
    NAME test-charset-r-ebcdic
    COMMAND ${SHELL} -c "./test-charset-r EBCDIC < ${CMAKE_CURRENT_SOURCE_DIR}/test-ebcdic.input | diff - ${CMAKE_CURRENT_SOURCE_DIR}/test-ebcdic.output"
)