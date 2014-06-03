template <> struct Factorial<4> {
    enum { value = 24 };
};

template <> struct Factorial<3> {
    enum { value = 6 };
};

template <> struct Factorial<2> {
    enum { value = 2 };
};

template <> struct Factorial<1> {
    enum { value = 1 };
};

template <> struct Factorial<0> {
    enum { value = 1 };
};

int main()
{
    int x = Factorial<4>::value;
    int y = Factorial<0>::value;
}

