platforms = { "macos" }
build_system_files = {}
print_version_cmd = "xcodebuild -version"
compdb_dir = "."
generate_compdb_cmd = {"xcodebuild | xcpretty --report json-compilation-database -o compile_commands.json",
                       "cat compile_commands.json | jq '.[0]' | jq -s | sponge compile_commands.json",
                       "sed -E 's/\-ivfsstatcache.*\.sdkstatcache//g' compile_commands.json | sponge compile_commands.json"}
