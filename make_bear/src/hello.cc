#include <iostream>

#include "hello.h"

auto main() -> int {
    Hello h;
    std::cout << h.hello() << '\n';
    return 0;
}
