add_custom_command(
    OUTPUT scanner.c
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l
    COMMAND ${SHELL}
    ARGS -c "${TEST_ENV_VARS} $<TARGET_FILE:flex> ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l"
)

add_executable(test-unicode-r
    scanner.c
)

add_test(
    NAME test-unicode-r
    COMMAND ${SHELL} -c "./test-unicode-r < ${CMAKE_CURRENT_SOURCE_DIR}/test.input | diff -a - ${CMAKE_CURRENT_SOURCE_DIR}/test.output"
)