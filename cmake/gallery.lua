build_system_files = {"CMakeLists.txt"}
print_version_cmd = "cmake --version"
compdb_dir = "debug"
generate_compdb_cmd = "cmake -S . -B " .. compdb_dir
