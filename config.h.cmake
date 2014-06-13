#define PACKAGE "${PACKAGE}"

#cmakedefine ENABLE_NLS 1

#cmakedefine HAVE_ALLOCA_H 1

#cmakedefine HAVE_ASSERT_H 1

#cmakedefine HAVE_LIMITS_H 1

#cmakedefine HAVE_UNISTD_H 1

#cmakedefine HAVE_NETINET_IN_H 1

#cmakedefine HAVE_SYS_PARAMS_H 1

#cmakedefine HAVE_SYS_WAIT_H 1

#cmakedefine HAVE_STDBOOL_H 1

#cmakedefine HAVE_REGEX_H 1

#cmakedefine HAVE_LOCALE_H 1

#cmakedefine HAVE_STDLIB_H 1

#if (!defined STDC_HEADERS) && HAVE_STDLIB_H
#define STDC_HEADERS
#endif

