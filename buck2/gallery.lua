build_system_files = {"BUCK"}
print_version_cmd = "buck2 --version"
setup_cmd = "buck2 init"
compdb_dir = "."
generate_compdb_cmd = {"buck2 build \"//:hello[compilation-database]\"",
                       "buck2 targets --show-json-output \"//:hello[compilation-database]\" | jq -r '.\"root//:hello[compilation-database]\"' | xargs -I {} cp {} .",
                       "jq --arg PWD_DIR ${PWD} '.[] |= (.directory = \"\\($PWD_DIR)\")' compile_commands.json | sponge compile_commands.json"}
