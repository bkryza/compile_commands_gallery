.PHONY: all cmake xmake make_bear make_compile_flags bazel_bazel_compile_commands_extractor b2 buck2 scons

CLANG_TIDY_BIN ?= clang-tidy-18
CLANG_UML_BIN ?= ~/devel/clang-uml/release/src/clang-uml

define print_header
    @echo "============================"
    @echo " $(1) "
    @echo "============================"
endef

cmake:
	$(call print_header,cmake)
	cd cmake && \
	cmake -S . -B debug && \
	$(CLANG_TIDY_BIN) -p debug src/hello.cc && \
	$(CLANG_UML_BIN)

xmake:
	$(call print_header,xmake)
	cd xmake && \
	xmake project -k compile_commands && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

make_bear:
	$(call print_header,Bear with Makefile)
	cd make_bear && \
	make clean && \
	bear -- make hello && \
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
	bazel run :refresh_compile_commands && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

b2:
	$(call print_header,b2)
	cd b2 && \
	b2 --command-database=json && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

buck2:
	$(call print_header,buck2)
	cd buck2 && \
	buck2 build "//:hello[compilation-database]" && \
	COMP_DB=$$(buck2 targets --show-json-output "//:hello[compilation-database]" | jq -r '."root//:hello[compilation-database]"'); cp $$COMP_DB . && \
	jq '.[] |= (.directory = "${PWD}/buck2")' compile_commands.json | sponge compile_commands.json && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

scons:
	$(call print_header,scons)
	cd scons && \
	scons compile_commands.json && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)



all: cmake xmake make_bear make_compile_flags bazel_bazel_compile_commands_extractor b2 buck2 scons
