# find needed utilities
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

find_program(M4 "m4")

find_program(SED "sed")
find_program(SHELL "sh")

# setup configuration variables
set(DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set(LOCALEDIR "${DATADIR}/locale")

# add required definitions and include paths
add_definitions(-DVERSION="${FLEX_VERSION}")
add_definitions(-DM4="${M4}")
add_definitions(-DHAVE_CONFIG_H)
add_definitions(-DLOCALEDIR="${LOCALEDIR}/")
include_directories("${CMAKE_SOURCE_DIR}/intl")

# goal to generate skel.c
add_custom_command(
	OUTPUT skel.c
	DEPENDS flex.skl mkskel.sh flexint.h tables_shared.h
	COMMAND ${SED} 's/m4_/m4postproc_/g\; s/m4preproc_/m4_/g' ${CMAKE_CURRENT_SOURCE_DIR}/flex.skl | ${M4} -P -DFLEX_MAJOR_VERSION=`echo \"${FLEX_VERSION}\"|cut -f 1 -d .` -DFLEX_MINOR_VERSION=`echo \"${FLEX_VERSION}\"|cut -f 2 -d .` -DFLEX_SUBMINOR_VERSION=`echo \"${FLEX_VERSION}\"|cut -f 3 -d .` -I${CMAKE_CURRENT_SOURCE_DIR} | ${SED} 's/m4postproc_/m4_/g' | ${SHELL} ${CMAKE_CURRENT_SOURCE_DIR}/mkskel.sh  >skel.c
)

# input files scanner
flex_target(flex_input_scanner
	${CMAKE_CURRENT_SOURCE_DIR}/scan.l
	${CMAKE_CURRENT_BINARY_DIR}/scan.c
)

# input files parser
bison_target(flex_input_parser
	${CMAKE_CURRENT_SOURCE_DIR}/parse.y
	${CMAKE_CURRENT_BINARY_DIR}/parse.c
)

# setup include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# build flex
add_executable(flex
	ccl.c
	dfa.c
	ecs.c
	scanflags.c
	gen.c
	main.c
	misc.c
	nfa.c
	parse.c
	scan.c
	skel.c
	sym.c
	tblcmp.c
	yylex.c
	options.c
	scanopt.c
	buf.c
	tables.c
	tables_shared.c
	filter.c
	regex.c
)
target_link_libraries(flex m)

# create flex++
add_custom_target(flex++ ALL
	COMMAND ${CMAKE_COMMAND} -E create_symlink flex flex++
	DEPENDS flex
)

# build libfl
set(LIBFL_SOURCES
	libmain.c
	libyywrap.c
)
add_library(fl-static STATIC ${LIBFL_SOURCES})
add_library(fl-shared SHARED ${LIBFL_SOURCES})

set_target_properties(fl-static fl-shared
	PROPERTIES
		OUTPUT_NAME fl
		VERSION "2.0.0"
)

# installation scripts
install(TARGETS flex DESTINATION bin)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/FlexLexer.h" DESTINATION include)
install(CODE "
    MESSAGE(\"-- Creating symbolic link \\\"flex++\\\"\")
	EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E create_symlink flex flex++
       WORKING_DIRECTORY \"${CMAKE_INSTALL_PREFIX}/bin\"
    )
")
install(TARGETS fl-static DESTINATION lib)
install(TARGETS fl-shared DESTINATION lib)