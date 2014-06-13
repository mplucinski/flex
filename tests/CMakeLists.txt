list(APPEND TESTS_BISON
	"test-bison-nr"
	"test-bison-yylloc"
	"test-bison-yylval"
)
list(APPEND TESTS_CXX
	"test-c++-basic"
	"test-c++-multiple-scanners"
	"test-c++-yywrap"
)
list(APPEND TESTS_BUILDS_CXX
	"test-c++-basic"
	"test-c++-multiple-scanners"
	"test-c++-yywrap"
	"test-c-cpp-nr"
	"test-c-cpp-r"
)
list(APPEND TESTS_HEADER
	"test-header-r"
	"test-linedir-r"
	"test-top"
	"test-multiple-scanners-r"
	"test-multiple-scanners-nr"
)
list(APPEND TESTS_MULTIPLE
	"test-c++-multiple-scanners"
	"test-multiple-scanners-r"
	"test-multiple-scanners-nr"
)
list(APPEND TESTS_INPUT_AS_ARGUMENT
# other tests are given input in stdin
	"test-include-by-buffer"
	"test-include-by-push"
	"test-include-by-reentrant"
	"test-rescan-nr"
	"test-rescan-r"
)
list(APPEND TESTS_POSIXLY_CORRECT
	"test-posixly-correct"
)

macro(ADD_OWN_FLEX_TARGET SUFFIX)
	set(TEST_INPUT_MODULE "${TEST_SOURCE_DIR}/scanner${SUFFIX}.l")
	set(TEST_SCANNER_MODULE "${TEST_BINARY_DIR}/scanner${SUFFIX}${TEST_MODULE_SUFFIX}")
	add_custom_command(
		OUTPUT ${TEST_SCANNER_MODULE}
		DEPENDS ${TEST_INPUT_MODULE}
		COMMAND ${SHELL}
		ARGS -c "${TEST_ENV_VARS} $<TARGET_FILE:flex> ${TEST_FLEX_FLAGS} ${TEST_INPUT_MODULE}"
		WORKING_DIRECTORY ${TEST_BINARY_DIR}
	)
	set(TEST_SCANNER_MODULE ${TEST_SCANNER_MODULE} PARENT_SCOPE)
endmacro(ADD_OWN_FLEX_TARGET)

file(GLOB TEST_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/*")
foreach(TEST_DIR ${TEST_DIRS})
	get_filename_component(TEST_NAME ${TEST_DIR} NAME)

	set(TEST_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${TEST_NAME}")
	set(TEST_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME}-build")
	set(TEST_BINARY "${TEST_NAME}")

	if((NOT "${TEST_NAME}" STREQUAL "TEMPLATE")
			AND (IS_DIRECTORY "${TEST_DIR}"))
		if(EXISTS "${TEST_DIR}/CMakeLists.txt")
			add_subdirectory("${TEST_DIR}")
		else(EXISTS "${TEST_DIR}/CMakeLists.txt")
			message(STATUS "Adding test \"${TEST_NAME}\"")
			file(MAKE_DIRECTORY ${TEST_BINARY_DIR})

			set(TEST_SRCS "")

			list(FIND TESTS_BISON "${TEST_NAME}" TEST_WITH_BISON)
			list(FIND TESTS_CXX "${TEST_NAME}" TEST_WITH_CXX)
			list(FIND TESTS_BUILDS_CXX "${TEST_NAME}" TEST_WITH_BUILDS_CXX)
			list(FIND TESTS_HEADER "${TEST_NAME}" TEST_WITH_HEADER)
			list(FIND TESTS_MULTIPLE "${TEST_NAME}" TEST_WITH_MULTIPLE)
			list(FIND TESTS_INPUT_AS_ARGUMENT "${TEST_NAME}" TEST_WITH_INPUT_AS_ARGUMENT)
			list(FIND TESTS_POSIXLY_CORRECT "${TEST_NAME}" TEST_WITH_POSIXLY_CORRECT)

			set(TEST_FLEX_FLAGS "")
			if(NOT (TEST_WITH_CXX EQUAL -1))
				set(TEST_FLEX_FLAGS ${TEST_FLEX_FLAGS} "-+")
			endif()

			if(NOT (TEST_WITH_BUILDS_CXX EQUAL -1))
				set(TEST_MODULE_SUFFIX ".cpp")
			else()
				set(TEST_MODULE_SUFFIX ".c")
			endif()

			if(NOT (TEST_WITH_HEADER EQUAL -1))
				set(TEST_FLEX_FLAGS ${TEST_FLEX_FLAGS} "--header=scanner.h")
			endif()

			set(TEST_ENV_VARS "")
			if(NOT (TEST_WITH_POSIXLY_CORRECT EQUAL -1))
				set(TEST_ENV_VARS "POSIXLY_CORRECT=1")
			endif()

			if(NOT (TEST_WITH_MULTIPLE EQUAL -1))
				add_own_flex_target("-1")
				list(APPEND TEST_SRCS ${TEST_SCANNER_MODULE})
				add_own_flex_target("-2")
			else()
				add_own_flex_target("")
			endif()
			list(APPEND TEST_SRCS ${TEST_SCANNER_MODULE})

			if(NOT (TEST_WITH_BISON EQUAL -1))
				bison_target("${TEST_NAME}_input_parser"
					${TEST_SOURCE_DIR}/parser.y
					${TEST_BINARY_DIR}/parser${TEST_MODULE_SUFFIX}
					COMPILE_FLAGS "--defines --output-file=\"parser${TEST_MODULE_SUFFIX}\" --name-prefix=\"test\""
				)
				list(APPEND TEST_SRCS ${TEST_BINARY_DIR}/parser${TEST_MODULE_SUFFIX})
			endif()

			if(EXISTS "${TEST_SOURCE_DIR}/main.c")
				list(APPEND TEST_SRCS "${TEST_SOURCE_DIR}/main.c")
			endif()
			if(EXISTS "${TEST_SOURCE_DIR}/main.cpp")
				list(APPEND TEST_SRCS "${TEST_SOURCE_DIR}/main.cpp")
			endif()

			add_executable(${TEST_BINARY} ${TEST_SRCS})
			set_target_properties(${TEST_BINARY}
				PROPERTIES INCLUDE_DIRECTORIES "$<TARGET_FILE_DIR:flex>;${FLEX_SOURCE_DIR};${CMAKE_CURRENT_SOURCE_DIR};${FLEX_CMAKE_BINARY_DIR};${TEST_BINARY_DIR}"
			)

			set(TEST_INPUT_FILE "${TEST_SOURCE_DIR}/test.input")

			if(EXISTS ${TEST_INPUT_FILE})
				if(NOT (TEST_WITH_INPUT_AS_ARGUMENT EQUAL -1))
					set(TEST_CMD "${CMAKE_CURRENT_BINARY_DIR}/${TEST_BINARY} \"${TEST_INPUT_FILE}\"")
				else()
					set(TEST_CMD "${CMAKE_CURRENT_BINARY_DIR}/${TEST_BINARY} < \"${TEST_INPUT_FILE}\"")
				endif()
			else()
				set(TEST_CMD "${CMAKE_CURRENT_BINARY_DIR}/${TEST_BINARY}")
			endif()

			add_test(
				NAME ${TEST_BINARY}
				COMMAND ${SHELL} -c "${TEST_CMD}"
				WORKING_DIRECTORY ${TEST_BINARY_DIR}
			)
		endif(EXISTS "${TEST_DIR}/CMakeLists.txt")
	endif()
endforeach()

add_executable(test_strutils test_strutils.c)
add_test(test_strutils test_strutils)