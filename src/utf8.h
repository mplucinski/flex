/*  Copyright (c) 1990 The Regents of the University of California. */
/*  All rights reserved. */

/*  This code is derived from software contributed to Berkeley by */
/*  Vern Paxson. */

/*  The United States Government has rights in this work pursuant */
/*  to contract no. DE-AC03-76SF00098 between the United States */
/*  Department of Energy and the University of California. */

/*  This file is part of flex. */

/*  Redistribution and use in source and binary forms, with or without */
/*  modification, are permitted provided that the following conditions */
/*  are met: */

/*  1. Redistributions of source code must retain the above copyright */
/*     notice, this list of conditions and the following disclaimer. */
/*  2. Redistributions in binary form must reproduce the above copyright */
/*     notice, this list of conditions and the following disclaimer in the */
/*     documentation and/or other materials provided with the distribution. */

/*  Neither the name of the University nor the names of its contributors */
/*  may be used to endorse or promote products derived from this software */
/*  without specific prior written permission. */

/*  THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR */
/*  IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED */
/*  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR */
/*  PURPOSE. */

#ifndef FLEX_UTF8_H
#define FLEX_UTF8_H

#ifdef FLEX_UTF8_NO_SKELETON
#define YYFARGS2(t1, a1, t2, a2) \
    (t1 a1, t2 a2)
#define YYFARGS5(t1, a1, t2, a2, t3, a3, t4, a4, t5, a5) \
    (t1 a1, t2 a2, t3 a3, t4 a4, t5 a5)
#define M4_YY_CALL_LAST_ARG

#ifndef YY_FATAL_ERROR
#define YY_FATAL_ERROR(msg) yy_fatal_error( msg )
#endif

#include <uchar.h>
#define YY_CHAR char32_t

#endif

#ifndef FLEX_UTF8_NO_CONVERT
static uint32_t yycharset_convert_utf8_appendcont YYFARGS2(
        char*, source, int, count
    ) {
    uint32_t r = 0;
    for(int i = 0; i < count; ++i) {
        uint8_t byte = source[i];
        if((byte & 0xC0) != 0x80)
            YY_FATAL_ERROR("Invalid UTF-8 continuation byte");

        r |= (byte & 0x3F);
        if(i+1 < count)
            r <<= 6;
    }
    return r;
}

static size_t yycharset_convert_utf8 YYFARGS5(
        char*, source, size_t, source_bytes,
        YY_CHAR*, target, size_t, target_length,
        size_t*, converted_bytes) {
    size_t i = 0, j = 0;

#ifdef FLEX_UTF8_TRACE
    fprintf(stderr, "Converting %d bytes\n", (int)source_bytes);
    for(size_t iii = 0; iii < source_bytes; ++iii)
        fprintf(stderr, "      %d: 0x%02x\n", (int)iii, (unsigned int)(unsigned char)source[iii]);
#endif

    for(; i < source_bytes;) {
        if(j >= target_length)
            YY_FATAL_ERROR("Target buffer too small");

        uint8_t byte = source[i];
        if(byte >= 0x80 && sizeof(YY_CHAR) < 4)
            YY_FATAL_ERROR("Characters higher than U+007F need bigger alphabet. Consider using %unicode option in your parser");

        if(byte >= 0xF0) { //4 bytes
            if(i+3 >= source_bytes)
                break;
            target[j] = ((byte & 0x07) << 6*3) | yycharset_convert_utf8_appendcont(
                &source[i+1], 3 M4_YY_CALL_LAST_ARG);
            i += 4;
        } else if(byte >= 0xE0) { //3 bytes
            if(i+2 >= source_bytes)
                break;
            target[j] = ((byte & 0x0F) << 6*2) | yycharset_convert_utf8_appendcont(
                &source[i+1], 2 M4_YY_CALL_LAST_ARG);
            i += 3;
        } else if(byte >= 0xC2) { //2 bytes
            if(i+1 >= source_bytes)
                break;
            target[j] = ((byte & 0x1F) << 6*1) | yycharset_convert_utf8_appendcont(
                &source[i+1], 1 M4_YY_CALL_LAST_ARG);
            i += 2;
        } else { // 1 byte
            target[j] = byte;
            i += 1;
        }
        j += 1;
    }
    if(converted_bytes)
        *converted_bytes = i;

#ifdef FLEX_UTF8_TRACE
    fprintf(stderr, "Outputted %d characters\n", (int)j);
    for(size_t iii = 0; iii < j; ++iii)
        fprintf(stderr, "      %d: 0x%08x\n", (int)iii, (unsigned int)target[iii]);
#endif

    return j;
}
#endif

#ifdef FLEX_UTF8_NO_SKELETON
#undef YY_CHAR
#endif

#endif /* FLEX_UTF8_H */