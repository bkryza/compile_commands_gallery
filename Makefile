.PHONY: all cmake xmake make_bear make_compile_flags bazel_bazel_compile_commands_extractor b2

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
	b2 --command-database=json  && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)


all: cmake xmake make_bear make_compile_flags bazel_bazel_compile_commands_extractor b2
