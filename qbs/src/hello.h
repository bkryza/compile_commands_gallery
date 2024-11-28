#ifndef __HELLO_H__
#define __HELLO_H__

#include <string_view>

struct Hello {
    auto hello() const -> std::string_view { return "Hello, world!"; }
};

#endif
