platforms = {"windows"}
build_system_files = {"hello.sln", "hello.vcxproj", "hello.vcxproj.filters"}
print_version_cmd = "MSBuild.exe -version"
compdb_dir = "."
setup_cmd = {"git clone https://github.com/0xabu/MsBuildCompileCommandsJson.git",
             "cd MsBuildCompileCommandsJson && dotnet build && cd ..",
         	 "copy MsBuildCompileCommandsJson\\bin\\Debug\\netstandard2.0\\CompileCommandsJson.dll CompileCommandsJson.dll"}
generate_compdb_cmd = {"msbuild.exe -logger:\"%cd%\\msvc_msbuildcompilecommandsjson\\CompileCommandsJson.dll\""}
