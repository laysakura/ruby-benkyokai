#include <stdio.h>

#define def_func(s) void s() { \
    fputs(#s, stdout);    \
}

def_func(foo)
def_func(bar)
