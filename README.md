# compile_commands.json gallery

This repository contains examples showing how `compile_commands.json` can be generated for various build
systems and their plugins.

> For detailed explanation of steps required for each build system - check out [my blog](https://blog.bkryza.com/posts/compile-commands-json-gallery/).

These scripts are used by me to test whether one of my Clang tools - [clang-uml](https://github.com/bkryza/clang-uml) -
works with compilation databases generated by these build systems.

Each subdirectory contains the same C++ hello world project with minimal configuration for a given build system
require to build it and generate `compile_commands.json`.

The list of examples currently contains:
* [b2](https://www.boost.org/doc/libs/1_86_0/tools/build/doc/html/index.html) - [`b2`](./b2)
* [Bazel](https://bazel.build/)
  * [bazel-compile-commands-extractor](https://github.com/hedronvision/bazel-compile-commands-extractor) - [`bazel_bazel_compile_commands_extractor`](./bazel_bazel_compile_commands_extractor)
  * [bazel-compile-commands](https://github.com/kiron1/bazel-compile-commands) - [`bazel_bazel_compile_commands`](./bazel_bazel_compile_commands)
* [buck2](https://github.com/facebook/buck2) - [`buck2`](./buck2)
* [build2](https://build2.org) - [`build2`](./build2)
* [Clang++ with -MJ flag](https://clang.llvm.org/docs/JSONCompilationDatabase.html#supported-systems) - [`clang_mj`](./clang_mj)
* [CMake](https://cmake.org/) - [`cmake`](./cmake)
* [FASTBuild](https://www.fastbuild.org) - [`fastbuild`](./fastbuild)
* [make]()
  * [Bear](https://github.com/rizsotto/Bear) - [`make_bear`](./make_bear)
  * [compiledb](https://github.com/nickdiego/compiledb) - [`make_compiledb`](./make_compiledb)
  * [compile_flags.txt](https://clang.llvm.org/docs/JSONCompilationDatabase.html#alternatives) - [`make_compile_flags`](./make_compile_flags)
  * [VS Code Makefile Tools](https://github.com/Microsoft/vscode-makefile-tools) - [`make_vscode_makefile_tools`](./make_vscode_makefile_tools)
* [Meson Build](https://mesonbuild.com/) - [`mesonbuild`](./mesonbuild)
* [MSVC Clang Power Tools](https://clangpowertools.com/) - [`msvc_clang_power_tools`](./msvc_clang_power_tools)
* [MSVC MSBuildCompileCommandsJSON](https://github.com/0xabu/MsBuildCompileCommandsJson) - [`msvc_msbuildcompilecommandsjson`](./msvc_msbuildcompilecommandsjson)
* [Ninja](https://ninja-build.org/) - [`ninja`](./ninja)
* [Premake](https://premake.github.io/)
  * [premake-ecc](https://github.com/MattBystrin/premake-ecc) - [`premake_ecc`](./premake_ecc)
  * [premake-export-compile-commands](https://github.com/tarruda/premake-export-compile-commands) - [`premake_premake_export_compile_commands`](./premake_premake_export_compile_commands)
* [Qbs](https://qbs.io/) - [`qbs`](./qbs)
* [SCons](https://scons.org/) - [`scons`](./scons)
* [Waf](https://waf.io/) - [`waf`](./waf)
* [XCode](https://developer.apple.com/xcode/)
  * [xcpretty](https://github.com/xcpretty/xcpretty) - [`xcode_xcpretty`](./xcode_xcpretty)
* [xmake](https://xmake.io) - [`xmake`](./xmake)


# Generating compile commands
The project contains a top-level [Makefile](./Makefile), which can be used to generate compile commands for specific
build system and plugin combination.

## Directly on host

Most examples can be run on Linux, some on macos and MSVC specific on Windows.

```console
$ ./make.lua cmake
```

## In Docker

If you'd like to try any of the build systems without installing anything, just run:

```console
$ docker run --rm -it bkryza/compile-commands-gallery:20241202
```

Then either enter a specific subdirectory or run:
```console
$ ./make.lua <subdirectory>
```

## Example output

For instance, in case of `cmake` you should see the following output:

```
[root@a1dc70ba3f0b compile_commands_gallery]# ./make.lua cmake
============================
 cmake
============================
**Version**

```bash
$ cmake --version
cmake version 3.31.1

CMake suite maintained and supported by Kitware (kitware.com/cmake).
\`\`\`

**Instructions**

Create the following files:

`CMakeLists.txt`:
\`\`\`
cmake_minimum_required(VERSION 3.15)

project(hello)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(hello src/hello.cc)
\`\`\`


Execute the following command:

\`\`\`bash
$ cmake -S . -B debug

\`\`\`
-- The C compiler identification is Clang 19.1.4
-- The CXX compiler identification is Clang 19.1.4
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/clang-19 - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/clang++-19 - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done (0.3s)
-- Generating done (0.0s)
-- Build files have been written to: /compile_commands_gallery/cmake/debug

**Result**

\`\`\`json
[
{
  "directory": "/compile_commands_gallery/cmake/debug",
  "command": "/usr/bin/clang++-19    -o CMakeFiles/hello.dir/src/hello.cc.o -c /compile_commands_gallery/cmake/src/hello.cc",
  "file": "/compile_commands_gallery/cmake/src/hello.cc",
  "output": "CMakeFiles/hello.dir/src/hello.cc.o"
}
]
\`\`\`
4188 warnings generated.
```


# License

```
MIT License

Copyright (c) [2024] [Bartek Kryza <bkryza@gmail.com>]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```