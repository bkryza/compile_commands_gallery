#!/usr/bin/env lua

-- MIT License
--
-- Copyright (c) [2024] [Bartek Kryza <bkryza@gmail.com>]
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


--
-- Logging
--
verbose = os.getenv("VERBOSE") or "0"

local function debug(message)
    if tonumber(verbose) > 0 then
        print("[DEBUG]: " .. message)
    end
end

--
-- Basic utils
--
function contains(t, x)
    found = false
    for _, v in pairs(t) do
        if v == x then
            found = true
        end
    end
    return found
end

--
-- File system utils
--
local function shell(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result:match("^%s*(.-)%s*$") -- Trim whitespace
end

function read_file(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

local function file_exists(name)
   local f = io.open(name, "r")
   return f ~= nil and io.close(f)
end

local function execute_in_dir(dir, args)
    local cmd = table.concat(args, " ")
    debug("Executing command in dir " .. dir .. ": " .. cmd)
    os.execute("cd " .. dir .. " && " .. cmd)
end

--
-- Detect OS
--
os_name = "linux"
if package.config:sub(1,1) == "\\" then
  os_name = "windows"
elseif shell("uname -s") == "Darwin" then
  os_name = "macos"
end

--
-- Terminal output utils
--
COLOR_RED=1
COLOR_GREEN=2
COLOR_YELLOW=3
COLOR_BLUE=4
COLOR_MAGENTA=5
COLOR_CYAN=6
COLOR_WHITE=7

local color_end
local color_red
local color_green
local color_yellow
local color_blue
local color_magenta
local color_cyan
local color_white

if os_name == "windows" then
    color_end = ""
    color_red = ""
    color_green = ""
    color_yellow = ""
    color_blue = ""
    color_magenta = ""
    color_cyan = ""
    color_white = ""
else
    color_end = shell("tput sgr0")
    color_red = shell("tput setaf 1")
    color_green = shell("tput setaf 2")
    color_yellow = shell("tput setaf 3")
    color_blue = shell("tput setaf 4")
    color_magenta = shell("tput setaf 5")
    color_cyan = shell("tput setaf 6")
    color_white = shell("tput setaf 7")
end

local function start_color(color)
    shell("tput setaf " .. color)
end

local function end_color(color)
    shell("tput sgr0")
end

local function print_colorized(message, color)
    print(color .. message .. color_end)
end

local function print_colorized_cmds(cmds, color)
    if type(cmds) == "table" then
        for i, cmd in pairs(cmds) do
           print_colorized("$ " .. cmd, c)
        end
    else
        print_colorized("$ " .. cmds, c)
    end
end

--
-- Global settings
--
cc = os.getenv("CC") or "/usr/bin/clang-19"
cxx = os.getenv("CXX") or "/usr/bin/clang++-19"

clang_tidy_bin = os.getenv("CLANG_TIDY_BIN") or "clang-tidy"
clang_tidy_opts = os.getenv("CLANG_TIDY_OPTS") or "--quiet"
clang_uml_bin = os.getenv("CLANG_UML_BIN") or "clang-uml"
clang_uml_opts = os.getenv("CLANG_UML_OPTS") or "--quiet"

build_flags = string.format("CC=%s CXX=%s", cc, cxx)

sdk_root = ""

if os_name == "macos" then
  sdk_root = "SDK_ROOT=" .. shell("xcrun --show-sdk-path")
  clang_uml_opts = "--quiet --query-driver ."
end

if os_name == "windows" then
  build_flags = ""
end

--
-- Build specific settings
--
build_system_files = {}
print_version_cmd = nil
compdb_dir = "."
setup_cmd = nil
generate_compdb_cmd = {}
default_platforms = {os_name}

if os_name == "macos" then
    platforms = {"linux", "macos"}
    default_platforms = {"linux", "macos"}
end

platforms = default_platforms


--
-- Logic
--
local function generate_compile_commands(dir)
    local gallery_lua = dir .. "/gallery.lua"

    -- print header
    c = color_green
    print_colorized("============================", c)
    print_colorized(" " .. dir, c)
    print_colorized("============================", c)

    -- load build settings
    build_system_files = {}
    print_version_cmd = nil
    compdb_dir = "."
    setup_cmd = nil
    generate_compdb_cmd = {}
    platforms = default_platforms
    dofile(dir .. "/" .. "gallery.lua")

    if not contains(platforms, os_name) then
        print_colorized("'" .. dir .. "'" .. " is not supported on " .. os_name .. " - skipping", color_red)
        return
    end

    -- print setup command
    if type(setup_cmd) == "table" or setup_cmd then
        c = color_white
        print_colorized("**Setup**", c)
        print_colorized("", c)
        print_colorized("```bash", c)
        print_colorized_cmds(setup_cmd, c)
        print_colorized("```", c)
        print_colorized("", c)

        if type(setup_cmd) == "table" then
            for i, cmd in pairs(setup_cmd) do
                execute_in_dir(dir, {build_flags, cmd})
            end
        else
            execute_in_dir(dir, {build_flags, setup_cmd})
        end
    end

    -- print version
    c = color_blue
    print_colorized("**Version**", c)
    print_colorized("", c)
    print_colorized("```bash", c)
    print_colorized("$ " .. print_version_cmd, c)
    print_colorized(shell(print_version_cmd), c)
    print_colorized("```", c)
    print_colorized("", c)

    -- print instructions
    c = color_cyan
    print_colorized("**Instructions**", c)
    print_colorized("", c)

    if build_system_files and #build_system_files > 0 then
        print_colorized("Create the following files:", c)
        print_colorized("", c);
    end

    --   print contents of system files
    for i, bf in pairs(build_system_files) do
        print_colorized("`" .. bf .. "`:", c)
        print_colorized("```", c);
        print_colorized(read_file(dir .. "/" .. bf), c)
        print_colorized("```", c);
        print_colorized("", c);
    end

    --  print compile commands generation command
    print_colorized("", c);
    print_colorized("Execute the following command:", c)
    print_colorized("", c);
    print_colorized("```bash", c);

    print_colorized_cmds(generate_compdb_cmd, c)

    print_colorized("", c)

    print_colorized("```", c);

    if type(generate_compdb_cmd) == "table" then
        for i, cmd in pairs(generate_compdb_cmd) do
            execute_in_dir(dir, {build_flags, cmd})
        end
    else
        execute_in_dir(dir, {build_flags, generate_compdb_cmd})
    end

    -- print generated compilation database
    c = color_magenta
    print_colorized("", c)
    print_colorized("**Result**", c);
    print_colorized("", c);
    print_colorized("```json", c);
    compdb_dir = compdb_dir .. "/" or ""
    print_colorized(read_file(dir .. "/" .. compdb_dir .. "compile_commands.json"), c)
    print_colorized("```", c);

    -- run clang-tidy
    execute_in_dir(dir, {sdk_root, clang_tidy_bin, clang_tidy_opts, "-p", compdb_dir, "src/hello.cc"})

    -- run clang-uml
    execute_in_dir(dir, {sdk_root, clang_uml_bin, clang_uml_opts, "-d", compdb_dir})

end

local function handle_args(target)
    local gallery_lua = target .. "/gallery.lua"

    if target == "all" then
        for dir in io.popen("ls -d */"):lines() do
            if file_exists(dir:sub(1, -2) .. "/gallery.lua") then
                generate_compile_commands(dir:sub(1, -2))
            end
        end
    elseif target == "clean" then
        os.execute("true")
    elseif file_exists(gallery_lua) then
        generate_compile_commands(target)
    else
        print("Unknown project: " .. target)
    end
end

-- Main entry point
local args = {...}
if #args == 0 then
    print("Usage: lua make.lua <target>")
else
    handle_args(args[1])
end
