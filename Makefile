BUILD_DIR = ./build

PRJ = playground

ifeq ($(wildcard rocket-chip/src/main),)
  	$(shell git clone --depth=1 --recursive git@github.com:chipsalliance/rocket-chip.git rocket-chip)
	
	ifeq ($(wildcard rocket-chip/dependencies/diplomacy),)
  		$(shell cd rocket-chip && git submodule update --init --recursive)
	endif	
endif

test:
	mill -i $(PRJ).test

verilog:
	$(call git_commit, "generate verilog")
	mkdir -p $(BUILD_DIR)
	mill -i $(PRJ).runMain Elaborate --target-dir $(BUILD_DIR)

help:
	mill -i $(PRJ).runMain Elaborate --help

reformat:
	mill -i __.reformat

checkformat:
	mill -i __.checkFormat

bsp:
	mill -i mill.bsp.BSP/install

idea:
	mill -i mill.idea.GenIdea/idea

clean:
	-rm -rf $(BUILD_DIR)

dist-clean distclean: clean
	-rm -rf out/

.PHONY: test verilog help reformat checkformat clean

sim:
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "Write this Makefile by yourself."

-include ../Makefile
