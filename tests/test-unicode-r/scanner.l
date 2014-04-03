/*
 * This file is part of flex.
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
 * PURPOSE.
 */

%{
/* This test is for correctness of parsing unicode input. */

#include <stdio.h>
#include <stdlib.h>
#include "config.h"

%}

%option unicode
%option outfile="scanner.c" prefix="test"
%option nounput nomain noyywrap noinput reentrant
%option warn

/* tests of various unicode characters */

/* capturing ranges - note that ranges are not recommended when dealing with
various scripts in real applications */

/*PUNCTUATION    [ .,;?!'"ʻ-]*/
/* punctuation
U+0020 - U+002F
U+003A - U+0040
U+005B - U+0060
U+007B - U+007E
U+2000 - U+206F*/
/*PUNCTUATION    [ -/:-@\[-`{-~    -]*/
PUNCTUATION     [ -/:-@\[-`{-~ -⁯]


/*COMBINING      [\U0300-\U036F]*/
COMBINING      [̀-ͯ]
/*MODIFIER       [\U02B0-\U02FF]*/
MODIFIER       [ʰ-˿]

/* latin-us
U+0041 - U+005A
U+0061 - U+007A */
LATIN_US       {PUNCTUATION}|[A-Za-z]

/* latin
U+0041 - U+005A
U+0061 - U+007A
U+00C0 - U+00D6
U+00D8 - U+00F6
U+00F8 - U+02AF
U+1E00 - U+1EFF
U+200C
U+A722 - U+A78E
U+A790 - U+A793
U+A7A0 - U+A7AA */
LATIN          {PUNCTUATION}|{LATIN_US}|{COMBINING}|{MODIFIER}|[À-ÖØ-öø-ʯḀ-ỿ‌Ꜣ-ꞎꞐ-ꞓꞠ-Ɦ]

/* greek
U+0370 - U+0373
U+0376
U+0377
U+0386
U+0388 - U+038A
U+038C
U+038E - U+03A1
U+03A3 - U+03CE
U+03D8 - U+03E1*/
/*GREEK          {PUNCTUATION}|[Ͱ-ͳͶͷΆΈ-ΊΌΎ-ΡΣ-ώϘ-ϡ]*/

/* greek
U+0370 - U+03E1
U+03F0 - U+03FF
U+1F00 - U+1FFF*/
GREEK          {PUNCTUATION}|[Ͱ-ϡϰ-Ͽἀ-῿]


/* coptic
U+03E2 - U+03EF*/
COPTIC         [Ϣ-ϯ]

/* cyrlic
U+0400 - U+0481
U+048A - U+0527
U+A640 - U+A66E
U+A680 - U+A697*/
CYRLIC         {PUNCTUATION}|[Ѐ-ҁҊ-ԧꙀ-ꙮꚀ-ꚗ]

/* armenian
U+0020
U+0530 - U+058F*/
ARMENIAN       [ ԰-֏]

/* hebrew
U+0590 - U+05FF*/
HEBREW         {PUNCTUATION}|[֐-׿]

/* arabic
U+0020
U+0620 - U+064A
U+066E - U+06D3
U+06D5
U+06EE
U+06EF
U+06FA - U+06FC
U+06FF
U+0750 - U+077F
U+08A0
U+08A2 - U+08AC*/

/* arabic
U+0600 - U+06FF*/
ARABIC         {PUNCTUATION}|[؀-ۿ]
/* ؠ-يٮ-ۓەۮۯۺ-ۼۿݐ-ݿࢠࢢ-ࢬ]*/

/* syriac
U+0710 - U+072F
U+074D - U+074F*/
SYRIAC         [ܐ-ܯݍ-ݏ]

/* thaana
U+0780 - U+07A5
U+07B1*/
THAANA         [ހ-ޥޱ]

/* nko
U+07CA - U+07EA*/
NKO            [ߊ-ߪ]

/* samaritian
U+0800 - U+0815*/
SAMARITIAN     [ࠀ-ࠕ]

/* mandaic
U+0840 - U+0858*/
MANDAIC        [ࡀ-ࡘ]

/* devanagari
U+0020
U+0900 - U+0965
U+0958 - U+095F
U+0972 - U+0977
U+0979 - U+097F*/
DEVANAGARI     {PUNCTUATION}|[ ऀ-॥क़-य़ॲ-ॷॹ-ॿ]

/* bengali
U+0020
U+0964
U+0965
U+0980 - U+09FF*/
BENGALI        {PUNCTUATION}|[ ।॥ঀ-৿]

/* gurmukhi
U+0A05 - U+0A0A
U+0A0F
U+0A10
U+0A13 - U+0A28
U+0A2A - U+0A30
U+0A32
U+0A33
U+0A35
U+0A36
U+0A38
U+0A39
U+0A59 - U+0A5C
U+0A5E*/
GURMUKHI       [ਅ-ਊਏਐਓ-ਨਪ-ਰਲਲ਼ਵਸ਼ਸਹਖ਼-ੜਫ਼]

/* gujarati
U+0A85 - U+0A91
U+0A93 - U+0AA8
U+0AAA - U+0AB0
U+0AB2
U+0AB3
U+0AB5 - U+0AB9*/
GUJARATI       [અ-ઑઓ-નપ-રલળવ-હ]

/* oriya
U+0B05 - U+0B0C
U+0B0F
U+0B10
U+0B13 - U+0B28
U+0B2A - U+0B30
U+0B32
U+0B33
U+0B35 - U+0B39
U+0B5C
U+0B5D
U+0B5F - U+0B61
U+0B71*/
ORIYA          [ଅ-ଌଏଐଓ-ନପ-ରଲଳଵ-ହଡ଼ଢ଼ୟ-ୡୱ]

/* tamil
U+0B80 - U+0BFF*/
TAMIL          {PUNCTUATION}|[ ஀-௿]

/* telugu
U+0C00 - U+0C7F*/
TELUGU         [ ఀ-౿]

/* kannada
U+0C80 - U+0CFF*/
KANNADA        {PUNCTUATION}|[ಀ-೿]

/* sinhala
U+0D80 - U+0DFF*/
SINHALA        {PUNCTUATION}|[඀-෿]

/* thai
U+0E00 - U+0E7F*/
THAI           {PUNCTUATION}|[฀-๿]

/* lao
U+0E80 - U+0EFF*/
LAO            {PUNCTUATION}|[຀-໿]

/* tibetan
U+0F00 - U+0FFF*/
TIBETAN        [ༀ-࿿]

/* myanmar
U+1000 - U+109F*/
MYANMAR        {PUNCTUATION}|[က-႟]

/* georgian
U+10A0 - U+10FF*/
GEORGIAN       {PUNCTUATION}|[Ⴀ-ჿ]

/* canadian
U+0020
U+1400 - U+167F*/
CANADIAN       [ ᐀-ᙿ]

/* ogham
U+1680 - U+169C*/
OGHAM          [ -᚜]

/* runic
U+0020
U+16A0 - U+16F0*/
RUNIC          [ ᚠ-ᛰ]

/* khmer
U+1780 - U+17FF*/
KHMER          {PUNCTUATION}|[ក-៿]

/* mongolian
U+1800 - U+18AF*/
MONGOLIAN      {PUNCTUATION}|[᠀-᢯]

/* braille
U+2800 - U+28FF*/
BRAILLE        [⠀-⣿]

/* hiragana
U+3041 - U+3096*/
HIRAGANA       [ぁ-ゖ]

/* katakana
U+309D - U+30FA
U+31F0 - U+31FF
U+1B000
U+1B001*/
KATAKANA       [ァ-ヺㇰ-ㇿ𛀀𛀁]

/* cjk
U+3400 - U+4DB5
U+4E00 - U+9FCC
U+F900 - U+FAD9
U+20000 - U+2A6D6
U+2A700 - U+2B734
U+2B740 - U+2B81D
U+2F800 - U+2FA1D*/
/*CJK            {PUNCTUATION}|[㐀-䶵一-鿌豈-龎𠀀-𪛖𪜀-𫜴𫝀-𫠝丽-𪘀]*/

/* cjk
U+2E80 - U+3040
U+3400 - U+4DBF
U+4E00 - U+9FFF
U+F900 - U+FAFF
U+20000 - U+2A6DF
U+2A700 - U+2B81D
U+2F800 - U+2FA1D*/
CJK            [ ⺀-぀㐀-䶿一-鿿豈-﫿𠀀-𪛟𪜀-𫠝丽-𪘀]


/* hexagram
U+4DC0 - U+4DFF*/
HEXAGRAM       [䷀-䷿]

/* yi
U+A000 - U+A48C*/
YI             [ꀀ-ꒌ]

/* lisu
U+A4D0 - U+A4F7*/
LISU           [ꓐ-ꓷ]

/* vai
U+A500 - U+A60C
U+A610 - U+A612
U+A62A
U+A62B*/
VAI            [ꔀ-ꘌꘐ-ꘒꘪꘫ]

/* hangul
U+AC00 - U+D7A3*/
HANGUL         {PUNCTUATION}|[가-힣]

/* old italic
U+10300 - U+1031E*/
OLD_ITALIC     [𐌀-𐌞]

/* gothic
U+10330 - U+1034A*/
GOTHIC         {PUNCTUATION}|{COMBINING}|[𐌰-𐍊]

/* ugaritic
U+10380 - U+1039D*/
UGARITIC       [𐎀-𐎝]

/* old persian
U+103A0 - U+103C3
U+103C8 - U+*/
OLD_PERSIAN    [𐎠-𐏃𐏈-𐏏]

/* phoenician
U+10900 - U+10915*/
PHOENICIAN     [𐤀-𐤕]

/* egyptian hieroglyphs
U+13000 - U+1342E*/
HIEROGLYPHS    {PUNCTUATION}|[𓀀-𓐮]

%%

{LATIN_US}+     { fprintf(yyout, "[LATIN_US]"); }
{LATIN}+        { fprintf(yyout, "[LATIN]"); }
{GREEK}+        { fprintf(yyout, "[GREEK]"); }
{COPTIC}+       { fprintf(yyout, "[COPTIC]"); }
{CYRLIC}+       { fprintf(yyout, "[CYRLIC]"); }
{ARMENIAN}+     { fprintf(yyout, "[ARMENIAN]"); }
{HEBREW}+       { fprintf(yyout, "[HEBREW]"); }
{ARABIC}+       { fprintf(yyout, "[ARABIC]"); }
{SYRIAC}+       { fprintf(yyout, "[SYRIAC]"); }
{THAANA}+       { fprintf(yyout, "[THAANA]"); }
{NKO}+          { fprintf(yyout, "[NKO]"); }
{SAMARITIAN}+   { fprintf(yyout, "[SAMARITIAN]"); }
{MANDAIC}+      { fprintf(yyout, "[MANDAIC]"); }
{DEVANAGARI}+   { fprintf(yyout, "[DEVANAGARI]"); }
{BENGALI}+      { fprintf(yyout, "[BENGALI]"); }
{GURMUKHI}+     { fprintf(yyout, "[GURMUKHI]"); }
{GUJARATI}+     { fprintf(yyout, "[GUJARATI]"); }
{ORIYA}+        { fprintf(yyout, "[ORIYA]"); }
{TAMIL}+        { fprintf(yyout, "[TAMIL]"); }
{TELUGU}+       { fprintf(yyout, "[TELUGU]"); }
{KANNADA}+      { fprintf(yyout, "[KANNADA]"); }
{SINHALA}+      { fprintf(yyout, "[SINHALA]"); }
{THAI}+         { fprintf(yyout, "[THAI]"); }
{LAO}+          { fprintf(yyout, "[LAO]"); }
{TIBETAN}+      { fprintf(yyout, "[TIBETAN]"); }
{MYANMAR}+      { fprintf(yyout, "[MYANMAR]"); }
{GEORGIAN}+     { fprintf(yyout, "[GEORGIAN]"); }
{CANADIAN}+     { fprintf(yyout, "[CANADIAN]"); }
{OGHAM}+        { fprintf(yyout, "[OGHAM]"); }
{RUNIC}+        { fprintf(yyout, "[RUNIC]"); }
{KHMER}+        { fprintf(yyout, "[KHMER]"); }
{MONGOLIAN}+    { fprintf(yyout, "[MONGOLIAN]"); }
{BRAILLE}+      { fprintf(yyout, "[BRAILLE]"); }
{HIRAGANA}+     { fprintf(yyout, "[HIRAGANA]"); }
{KATAKANA}+     { fprintf(yyout, "[KATAKANA]"); }
{YI}+           { fprintf(yyout, "[YI]"); }
{LISU}+         { fprintf(yyout, "[LISU]"); }
{VAI}+          { fprintf(yyout, "[VAI]"); }
{CJK}+          { fprintf(yyout, "[CJK]"); }
({CJK}|{HIRAGANA}|{KATAKANA})+   { fprintf(yyout, "[JAPANESE]"); }
{HEXAGRAM}+     { fprintf(yyout, "[HEXAGRAM]"); }
{HANGUL}+       { fprintf(yyout, "[HANGUL]"); }
{OLD_ITALIC}+   { fprintf(yyout, "[OLD_ITALIC]"); }
{GOTHIC}+       { fprintf(yyout, "[GOTHIC]"); }
{UGARITIC}+     { fprintf(yyout, "[UGARITIC]"); }
{OLD_PERSIAN}+  { fprintf(yyout, "[OLD_PERSIAN]"); }
{PHOENICIAN}+   { fprintf(yyout, "[PHOENICIAN]"); }
{HIEROGLYPHS}+  { fprintf(yyout, "[HIEROGLYPHS]"); }
  /*\n              { fprintf(yyout, "\n"); }*/

%%

int main(void);

int
main ()
{
    yyscan_t lexer;
    yylex_init(&lexer);
    yyset_in(stdin, lexer);
    yyset_charset("UTF-8", lexer);
    yyset_out(stdout, lexer);
    yylex(lexer);
    yylex_destroy(lexer);
    return 0;
}
