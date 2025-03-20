import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, Timer
from cocotb.utils import get_sim_time
import random

# --- TEST CYCLE ---
@cocotb.test(timeout_time=50, timeout_unit='sec')
async def run_smoke_case_cpu(dut):
    await reset_project(dut)
    await smoke_case_cpu(dut)
    
# --- HELPER FUNCTIONS ---
async def reset_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.rst.value = 1
    await ClockCycles(dut.clk, 20)
    dut.rst.value = 0
    await ClockCycles(dut.clk, 40)

async def smoke_case_cpu(dut):
    dut.inst_ram_ins.sram_ins_inst.mem[0].value = 0x06400313
    
    