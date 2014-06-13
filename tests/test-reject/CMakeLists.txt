message(STATUS "Adding test \"test-reject\"")

include(FindPackageHandleStandardArgs)

macro(add_local_test TEST_NAME TEST_RUN_FLAGS TEST_BUILD_FLAGS TEST_FLEX_FLAGS)
	set(TEST_SCANNER_C "${TEST_NAME}.c")
	set(TEST_SCANNER_L "${CMAKE_CURRENT_SOURCE_DIR}/scanner.l")

	add_custom_command(
		OUTPUT ${TEST_SCANNER_C}
		DEPENDS ${TEST_SCANNER_L}
		COMMAND $<TARGET_FILE:flex>
		ARGS -o ${TEST_SCANNER_C} ${TEST_FLEX_FLAGS} ${TEST_SCANNER_L}
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

add_local_test(test-reject-nr
	""
	""
	""
)

add_local_test(test-reject-r
	""
	"-DTEST_IS_REENTRANT"
	"--reentrant"
)

add_local_test(test-reject-ser
	"test-reject-ser.tables"
	"-DTEST_HAS_TABLES_EXTERNAL"
	"--tables-file=test-reject-ser.tables"
)

add_local_test(test-reject-ver
	"test-reject-ver.tables"
	"-DTEST_HAS_TABLES_EXTERNAL"
	"--tables-file=test-reject-ver.tables" "--tables-verify"
)