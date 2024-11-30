# MIT License
#
# Copyright (c) [2024] [Bartek Kryza <bkryza@gmail.com>]
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


OS_UNAME := $(shell uname -s)

ifeq ($(OS_UNAME),Linux)
  CC = /usr/bin/clang-19
  CXX = /usr/bin/clang++-19
  CLANG_TIDY_BIN ?= clang-tidy
  ClANG_TIDY_OPTS ?= --quiet
  CLANG_UML_BIN ?= clang-uml
  CLANG_UML_OPTS ?= "--quiet"
else ifeq ($(OS_UNAME),Darwin)
  LLVM_PREFIX = $(shell brew --prefix llvm)
  CC = $(LLVM_PREFIX)/bin/clang
  CXX = $(LLVM_PREFIX)/bin/clang++
  CLANG_TIDY_BIN ?= $(LLVM_PREFIX)/bin/clang-tidy
  ClANG_TIDY_OPTS ?= --quiet
  CLANG_UML_BIN ?= clang-uml
  CLANG_UML_OPTS ?= "--quiet --query-driver ."
endif

BUILD_FLAGS="CC=$(CC) CXX=$(CXX)"

.PHONY: phony
phony:

COLOR_GREEN = 2

%: phony
	@if [ -d "$@" ]; then \
		printf "$(shell tput setaf $(COLOR_GREEN))============================\n"; \
		printf " $@ \n"; \
		printf "============================$(shell tput sgr0)\n"; \
		CLANG_TIDY_BIN=$(CLANG_TIDY_BIN) CLANG_TIDY_OPTS=$(CLANG_TIDY_OPTS) CLANG_UML_BIN=$(CLANG_UML_BIN) CLANG_UML_OPTS=$(CLANG_UML_OPTS) make -C $@ -s -f Makefile.ccj; \
	elif [ "$@" = "Makefile" ]; then \
		true; \
	elif [ "$@" = "all" ]; then \
		for dir in */; do \
			if [ -f "$${dir}Makefile.ccj" ]; then \
				echo "\n"; \
				make -C . BUILD_FLAGS=$(BUILD_FLAGS) $$dir; \
			fi; \
		done; \
	else \
		echo "Unknown project: $@"; \
	fi

.PHONY: clean
clean:
	git clean -dfx