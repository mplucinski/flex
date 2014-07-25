/* This file is part of flex.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the University nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE
 */

/*
 * This test verifies that utility functions in `src/yychar.h` are working
 * properly.
 */

#include <stdint.h>
#include <stdio.h>


#define YY_CHAR uint32_t
#include "yychar.h"

#define STR(x) (#x)

#define CHECK(v) do{ \
        if(!(v)) { \
            fprintf(stderr, "Check failed: %s\n", STR(v)); \
            return 1; \
        } \
    }while(0)

int main(int argc, char **argv) {
    fprintf(stderr, "Starting strutils tests\n");

    (void)argc;
    (void)argv;

    YY_CHAR str[] = {'W', 'h', 'a', 't', ' ', 'a', ' ', 's', 't', 'r', 'i', 'n', 'g', '!', 0};

    /* yychar_strlen */
    CHECK(yychar_strlen(str) == 14);

    /* yychar_strcpy, yychar_strcmp */
    YY_CHAR dst1[15];
    yychar_strcpy(dst1, str);
    CHECK(yychar_strcmp(dst1, str) == 0);

    /* yychar_strdup */
    YY_CHAR *dst2 = yychar_strdup(str);
    CHECK(yychar_strcmp(dst2, str) == 0);
    free(dst2);

    /* yychar_strtol */
    YY_CHAR i1s[] = {' ', '\t', '\r', '\n', '1', '2', '3', 'a', 's', 'd', 0};
    YY_CHAR *endptr;
    CHECK(yychar_strtol(i1s, &endptr, 10) == 123);
    CHECK(endptr == i1s+7);
    CHECK(yychar_strtol(i1s, &endptr, 16) == 0x123a);
    CHECK(endptr == i1s+8);

    YY_CHAR i2s[] = {' ', '\t', '\r', '\n', '-', '1', '2', '3', 'a', 's', 'd', 0};
    CHECK(yychar_strtol(i2s, &endptr, 10) == -123);
    CHECK(endptr == i2s+8);
    CHECK(yychar_strtol(i2s, &endptr, 16) == -0x123a);
    CHECK(endptr == i2s+9);

    fprintf(stderr, "Tests succeeded\n");
    return 0;
}