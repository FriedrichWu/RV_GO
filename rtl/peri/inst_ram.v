module inst_ram (
  input         clk1,
  input  [31:0] addr1,
  output [31:0] instr
);
//----------------------------------------------//
//INTERNAL SIGNAL
//----------------------------------------------//
sky130_sram_2kbyte_1rw1r_32x512_8 sram_ins_inst (
  .clk0        (),
  .csb0        (),
  .web0        (),
  .wmask0      (),
  .addr0       (),
  .din0        (),
  .dout0       (),
  .clk1        (clk1     ),
  .csb1        (1'b0     ),
  .addr1       (addr[8:0]),
  .dout1       (instr    )
);
    
endmodule