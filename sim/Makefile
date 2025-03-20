# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../rtl/core/*.v
# use VHDL_SOURCES for VHDL files

# simulation module
VERILOG_SOURCES += $(PWD)/../rtl/peri/*.v

# testbench (instances)
VERILOG_SOURCES += $(PWD)/tb.v

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = tb

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim