build_system_files = {}
print_version_cmd = "clang++-19 --version"
compdb_dir = "."
generate_compdb_cmd = {"clang++-19 -MJ hello.o.json -Wall -std=c++17 -Isrc -o hello.o -c src/hello.cc",
                       "cat hello.o.json | sed 's/},$/}/' | jq -s . | sponge compile_commands.json"}
