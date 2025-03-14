module inst_ram (
  input         clk1,
  input  [ 8:0] addr1,
  output [31:0] instr
);
//----------------------------------------------//
//INTERNAL SIGNAL
//----------------------------------------------//
sky130_sram_2kbyte_1rw1r_32x512_8 inst_ram_ins(
  .clk0 (),
  .csb0 (),
  .web0 (),
  .wmask0 (),
  .addr0 (),
  .din0 (),
  .dout0 (),
  .clk1 (clk1),
  .csb1 (1'b0),
  .addr1 (addr1),
  .dout1 (instr)
);
	
endmodule