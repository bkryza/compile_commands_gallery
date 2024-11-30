platforms = {"linux", "macos", "windows"}
build_system_files = {"BUILD", "MODULE.bazel"}
print_version_cmd = "bazel --version"
compdb_dir = "."
generate_compdb_cmd = "bazel run :refresh_compile_commands"
