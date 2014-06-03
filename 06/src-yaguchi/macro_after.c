#include <stdio.h>

#define def_func(s) void s() { \
    fputs(#s, stdout);         \
}

void foo() { fputs("foo", stdout); }
void bar() { fputs("bar", stdout); }
