project(Flex C CXX)
cmake_minimum_required(VERSION 2.8)

enable_testing()

set(FLEX_VERSION "2.6.0-pre")

# set up packaging
set(FLEX_PACKAGE_NAME "the fast lexical analyser generator")
set(PACKAGE "flex")
set(CPACK_PACKAGE_NAME "${PACKAGE}")
set(CPACK_PACKAGE_VERSION "${FLEX_VERSION}")

include(CPack)

# options
option(ENABLE_NLS "Enables Native Language Support" ON)

# prepare config.h
find_file(HAVE_ALLOCA_H NAMES "alloca.h")
find_file(HAVE_ASSERT_H NAMES "assert.h")
find_file(HAVE_LIMITS_H NAMES "limits.h")
find_file(HAVE_UNISTD_H NAMES "unistd.h")
find_file(HAVE_NETINET_IN_H NAMES "netinet/in.h")
find_file(HAVE_SYS_PARAMS_H NAMES "sys/params.h")
find_file(HAVE_SYS_WAIT_H NAMES "sys/wait.h")
find_file(HAVE_STDBOOL_H NAMES "stdbool.h")
find_file(HAVE_REGEX_H NAMES "regex.h")
find_file(HAVE_LOCALE_H NAMES "locale.h")
find_file(HAVE_STDLIB_H NAMES "stdlib.h")

configure_file(config.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config.h)

# all sources should have access to config.h
set(FLEX_CMAKE_BINARY_DIR "${CMAKE_BINARY_DIR}")
include_directories("${FLEX_CMAKE_BINARY_DIR}")

# include directories
add_subdirectory(lib)
add_subdirectory(src)
add_subdirectory(doc)
add_subdirectory(po)
add_subdirectory(tests)

# install scripts
install(FILES AUTHORS COPYING NEWS ONEWS README
	DESTINATION "share/doc/flex"
)