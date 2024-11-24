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

CLANG_TIDY_BIN ?= clang-tidy-18
CLANG_UML_BIN ?= ~/devel/clang-uml/debug/src/clang-uml


.PHONY: phony
phony:

%: phony
	@if [ -d "$@" ]; then \
		echo "============================"; \
		echo " $@ "; \
		echo "============================"; \
		CLANG_TIDY_BIN=$(CLANG_TIDY_BIN) CLANG_UML_BIN=$(CLANG_UML_BIN) make -C $@ -f Makefile.ccj; \
	elif [ "$@" = "Makefile" ]; then \
		true; \
	elif [ "$@" = "all" ]; then \
		for dir in */; do \
			if [ -f "$${dir}Makefile.ccj" ]; then \
				echo "\n"; \
				make -C . $$dir; \
			fi; \
		done; \
	else \
		echo "Unknown project: $@"; \
	fi