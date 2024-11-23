.PHONY: all cmake clang_mj xmake make_bear make_compiledb make_compile_flags bazel_bazel_compile_commands_extractor b2 buck2 scons mesonbuild premake_premake_export_compile_commands premake_ecc

CLANG_TIDY_BIN ?= clang-tidy-18
CLANG_UML_BIN ?= ~/devel/clang-uml/debug/src/clang-uml

define print_header
    @echo "============================"
    @echo " $(1) "
    @echo "============================"
endef

cmake:
	$(call print_header,cmake)
	cd cmake && \
	cmake --version && \
	cmake -S . -B debug && \
	$(CLANG_TIDY_BIN) -p debug src/hello.cc && \
	$(CLANG_UML_BIN)

clang_mj:
	$(call print_header,clang++ with -MJ flag)
	cd clang_mj && \
	clang++ -MJ hello.o.json -Wall -std=c++17 -Isrc -o hello.o -c src/hello.cc && \
	cat hello.o.json | sed 's/},$$/}/' | jq -s . | sponge compile_commands.json && \
	$(CLANG_TIDY_BIN) -p debug src/hello.cc && \
	$(CLANG_UML_BIN)

xmake:
	$(call print_header,xmake)
	cd xmake && \
	xmake --version && \
	xmake project -k compile_commands && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

make_bear:
	$(call print_header,make with Bear)
	cd make_bear && \
	make clean && \
	bear --version && \
	bear -- make hello && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

make_compiledb:
	$(call print_header,make with compiledb)
	cd make_compiledb && \
	make clean && \
	pip3 list | grep compiledb && \
	compiledb make && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

make_compile_flags:
	$(call print_header,Makefile with compile_flags.txt)
	cd make_compile_flags && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

bazel_bazel_compile_commands_extractor:
	$(call print_header,Bazel with bazel_compile_commands_extractor)
	cd bazel_bazel_compile_commands_extractor && \
	bazel --version && \
	bazel run :refresh_compile_commands && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

b2:
	$(call print_header,b2)
	cd b2 && \
	b2 --version || true && \
	b2 --command-database=json && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

buck2:
	$(call print_header,buck2)
	cd buck2 && \
	buck2 --version && \
	buck2 build "//:hello[compilation-database]" && \
	COMP_DB=$$(buck2 targets --show-json-output "//:hello[compilation-database]" | jq -r '."root//:hello[compilation-database]"'); cp $$COMP_DB . && \
	jq '.[] |= (.directory = "${PWD}/buck2")' compile_commands.json | sponge compile_commands.json && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

scons:
	$(call print_header,scons)
	cd scons && \
	scons --version && \
	scons compile_commands.json && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

mesonbuild:
	$(call print_header, mesonbuild)
	cd mesonbuild && \
	meson --version && \
	meson setup builddir && \
	$(CLANG_TIDY_BIN) -p builddir src/hello.cc && \
	$(CLANG_UML_BIN) -d builddir

premake_premake_export_compile_commands:
	$(call print_header, premake with premake-export-compile-commands)
	cd premake_premake_export_compile_commands && \
	premake5 --version && \
	git clone https://github.com/tarruda/premake-export-compile-commands export-compile-commands || true && \
	premake5 export-compile-commands && \
	cp compile_commands/debug.json compile_commands.json && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

premake_ecc:
	$(call print_header, premake with ecc)
	cd premake_ecc && \
	premake5 --version && \
	git clone git@github.com:MattBystrin/premake-ecc.git ecc || true && \
	premake5 ecc && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

all: cmake clang_mj xmake make_bear make_compiledb make_compile_flags bazel_bazel_compile_commands_extractor b2 buck2 scons mesonbuild premake_premake_export_compile_commands premake_ecc
