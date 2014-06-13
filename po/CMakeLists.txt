# load package
include(FindGettext)
find_program(XGETTEXT "xgettext")

# generate pot file
add_custom_command(OUTPUT flex.pot
	COMMAND ${XGETTEXT} --default-domain=flex --directory=${CMAKE_CURRENT_SOURCE_DIR}/.. --add-comments=TRANSLATORS: --keyword=_ --keyword=N_ --files-from=${CMAKE_CURRENT_SOURCE_DIR}/POTFILES.in --copyright-holder='' --package-name=${CPACK_PACKAGE_NAME} --package-version=${FLEX_VERSION} --output=flex.pot
)

# generate mo files
set(VARIANTS
	ca
	da
	de
	eo
	es
	fi
	fr
	ga
	hr
	ko
	nl
	pl
	pt_BR
	ro
	ru
	sr
	sv
	tr
	vi
	zh_CN
	zh_TW
)

set(PO_FILES "")
foreach(VARIANT ${VARIANTS})
	list(APPEND PO_FILES "${VARIANT}.po")
endforeach()

#GETTEXT_PROCESS_PO_FILES( <lang> [ALL] [INSTALL_DESTINATION <dir>] PO_FILES <po1> <po2> ... )

GETTEXT_CREATE_TRANSLATIONS(${CMAKE_CURRENT_BINARY_DIR}/flex.pot ALL ${PO_FILES})
