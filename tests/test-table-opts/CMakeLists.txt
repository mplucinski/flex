message(STATUS "Adding test \"test-table-opts\"")

macro(add_local_test TEST_NAME TEST_RUN_FLAGS TEST_BUILD_FLAGS TEST_FLEX_FLAGS)
	set(TEST_SCANNER_C "${TEST_NAME}.c")
	set(TEST_SCANNER_L "${CMAKE_CURRENT_SOURCE_DIR}/scanner.l")

	string(REGEX REPLACE
		"-" "_"
		TEST_PREFIX ${TEST_NAME}
	)

	add_custom_command(
		OUTPUT ${TEST_SCANNER_C}
		DEPENDS ${TEST_SCANNER_L}
		COMMAND $<TARGET_FILE:flex>
		ARGS -L -P ${TEST_PREFIX} -o ${TEST_SCANNER_C} ${TEST_FLEX_FLAGS} ${ARGN} ${TEST_SCANNER_L}
	)

	add_executable(${TEST_NAME}
		${TEST_SCANNER_C}
	)
	set_property(TARGET ${TEST_NAME}
		PROPERTY COMPILE_FLAGS ${TEST_BUILD_FLAGS}
	)

	add_test(
		NAME ${TEST_NAME}
		COMMAND ${SHELL} -c "${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME} ${TEST_RUN_FLAGS} < \"${CMAKE_CURRENT_SOURCE_DIR}/test.input\""
	)
endmacro()

foreach(OPTION "-Ca" "-Ce" "-Cf" "-CF" "-Cm" "-Cem" "-Cae"
		"-Caef" "-CaeF" "-Cam" "-Caem")
	add_local_test("test-table-opt-nr${OPTION}"
		""
		""
		"" "${OPTION}"
	)
	add_local_test("test-table-opt-r${OPTION}"
		""
		"-DTEST_IS_REENTRANT"
		"--reentrant" "${OPTION}"
	)
	add_local_test("test-table-ser-nr${OPTION}"
		"test-ser-nr${OPTION}.tables"
		"-DTEST_HAS_TABLES_EXTERNAL"
		"--tables-file=test-ser-nr${OPTION}.tables" "${OPTION}"
	)
	add_local_test("test-table-ser-r${OPTION}"
		"test-ser-r${OPTION}.tables"
		"-DTEST_HAS_TABLES_EXTERNAL -DTEST_IS_REENTRANT"
		"-R" "--tables-file=test-ser-r${OPTION}.tables" "${OPTION}"
	)
	add_local_test("test-table-ver-nr${OPTION}"
		"test-ver-nr${OPTION}.tables"
		"-DTEST_HAS_TABLES_EXTERNAL"
		"--tables-file=test-ver-nr${OPTION}.tables" "${OPTION}"
	)
	add_local_test("test-table-ver-r${OPTION}"
		"test-ver-r${OPTION}.tables"
		"-DTEST_HAS_TABLES_EXTERNAL -DTEST_IS_REENTRANT"
		"-R" "--tables-file=test-ver-r${OPTION}.tables" "${OPTION}"
	)
endforeach()
