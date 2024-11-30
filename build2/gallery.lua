build_system_files = {"build/bootstrap.build", "build/root.build", "src/buildfile", "buildfile", "manifest"}
print_version_cmd = "b --version"
compdb_dir = "."
generate_compdb_cmd = {"b configure config.cxx.std=17 config.cxx=clang++-19",
                       "b config.cc.compiledb=compile_commands"}
