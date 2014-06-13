add_custom_command(
    OUTPUT scanner.c
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l
    COMMAND ${SHELL}
    ARGS -c "${TEST_ENV_VARS} $<TARGET_FILE:flex> ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l"
)

add_executable(test-charset-nr
    scanner.c
)

add_test(
    NAME test-charset-nr-ascii
    COMMAND ${SHELL} -c "./test-charset-nr ASCII < ${CMAKE_CURRENT_SOURCE_DIR}/test-ascii.input | diff -a - ${CMAKE_CURRENT_SOURCE_DIR}/test-ascii.output"
)
add_test(
    NAME test-charset-nr-ebcdic
    COMMAND ${SHELL} -c "./test-charset-nr EBCDIC < ${CMAKE_CURRENT_SOURCE_DIR}/test-ebcdic.input | diff -a - ${CMAKE_CURRENT_SOURCE_DIR}/test-ebcdic.output"
)