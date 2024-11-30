load("@hedron_compile_commands//:refresh_compile_commands.bzl", "refresh_compile_commands")

refresh_compile_commands(
    name = "refresh_compile_commands",
    exclude_headers = "all",
    targets = {"//:hello": ""},
)

cc_binary(
    name = "hello",
    srcs = ["src/hello.cc", "src/hello.h"],
    includes = ["src/"],
    cxxopts = ["-std=c++17"],
    visibility = ["//visibility:public"]
)