build_system_files = {"premake5.lua"}
print_version_cmd = "premake5 --version"
setup_cmd = "git clone https://github.com/tarruda/premake-export-compile-commands export-compile-commands || true"
compdb_dir = "."
generate_compdb_cmd = {"premake5 export-compile-commands",
                       "cp compile_commands/debug.json compile_commands.json"}
