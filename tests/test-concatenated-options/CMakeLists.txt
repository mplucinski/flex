add_test(NAME test-concatenated-options
    COMMAND ${SHELL} -c "echo %% | $<TARGET_FILE:flex> -cn -o /dev/null")
