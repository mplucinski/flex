add_custom_command(
    OUTPUT scanner.c
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l
    COMMAND ${SHELL}
    ARGS -c "${TEST_ENV_VARS} $<TARGET_FILE:flex> -o scanner.c ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l"
)

add_custom_command(
    OUTPUT scanner_full.c
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l
    COMMAND ${SHELL}
    ARGS -c "${TEST_ENV_VARS} $<TARGET_FILE:flex> --full --trace -o scanner_full.c ${CMAKE_CURRENT_SOURCE_DIR}/scanner.l"
)

add_executable(test-unicode-basic-nr
    scanner.c
)

add_executable(test-unicode-basic-nr-full
    scanner_full.c
)

add_test(
    NAME test-unicode-basic-nr
    COMMAND ${SHELL} -c "./test-unicode-basic-nr < ${CMAKE_CURRENT_SOURCE_DIR}/test.input | diff -a - ${CMAKE_CURRENT_SOURCE_DIR}/test.output"
)

add_test(
    NAME test-unicode-basic-nr-full
    COMMAND ${SHELL} -c "./test-unicode-basic-nr-full < ${CMAKE_CURRENT_SOURCE_DIR}/test.input | diff -a - ${CMAKE_CURRENT_SOURCE_DIR}/test.output"
)