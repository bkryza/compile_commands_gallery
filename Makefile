.PHONY: all cmake xmake make_bear make_compile_flags bazel_bazel_compile_commands_extractor

CLANG_TIDY_BIN ?= clang-tidy-18
CLANG_UML_BIN ?= ~/devel/clang-uml/debug/src/clang-uml

cmake:
	cd cmake && \
	cmake -S . -B debug && \
	$(CLANG_TIDY_BIN) -p debug src/hello.cc && \
	$(CLANG_UML_BIN)

xmake:
	cd xmake && \
	xmake project -k compile_commands && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

make_bear:
	cd make_bear && \
	make clean && \
	bear -- make hello && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

make_compile_flags:
	cd make_compile_flags && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)

bazel_bazel_compile_commands_extractor:
	cd bazel_bazel_compile_commands_extractor && \
	bazel run :refresh_compile_commands && \
	$(CLANG_TIDY_BIN) src/hello.cc && \
	$(CLANG_UML_BIN)


all: cmake xmake make_bear make_compile_flags bazel_bazel_compile_commands_extractor
