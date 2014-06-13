#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yy_fatal_error(char* msg);

#define YY_CHAR uint32_t

#define FLEX_UTF8_NO_SKELETON
#include "../src/utf8.h"

void yy_fatal_error(char* msg) {
    fprintf(stderr, "FATAL ERROR: %s\n", msg);
    exit(1);
}

int main(int argc, char **argv) {
    fprintf(stderr, "Starting strutils tests\n");

    (void)argc;
    (void)argv;

    int left = 0;
    char buffer[16];
    YY_CHAR target[sizeof(buffer)+1];

    memset(buffer, 0, sizeof(buffer));
    memset(target, 0, sizeof(target));

    while(!feof(stdin)) {
        size_t count = fread(buffer+left, 1, sizeof(buffer)/2, stdin);
        size_t converted = 0;
        size_t output = yycharset_convert_utf8(buffer, count+left, target, sizeof(target)/sizeof(target[0]), &converted);
        left = count+left-converted;
        memmove(buffer, buffer+converted, left);
        fwrite(target, sizeof(YY_CHAR), output, stdout);
    }

    fprintf(stderr, "Tests succeeded\n");
    return 0;
}