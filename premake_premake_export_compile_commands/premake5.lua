require "export-compile-commands"

workspace "hello"
   configurations { "Debug"}

project "hello"
   kind "ConsoleApp"
   language "C++"
   targetdir "bin/%{cfg.buildcfg}"

   files { "src/hello.h", "src/hello.cc" }

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"