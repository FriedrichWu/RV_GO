`timescale 1ns / 1ps

module tb ();

// Dump the signals to a VCD file. You can view it with gtkwave.
initial begin
  $dumpfile("tb.vcd");
  $dumpvars(0, tb);
  #1;
end
//--------------------------------------------------------------//
//INTERNAL SIGNAL
//--------------------------------------------------------------//
wire        clk;
wire        rst;
wire [31:0] instr;
wire [31:0] data_from_ram;
wire [31:0] alu_result_staged_m;
wire [31:0] data_to_ram_staged_m;
wire [31:0] nxt_pc;
wire [ 2:0] mem_op_staged_m;
wire        mem_w_staged_m;

rv_go_iiiii_core rv_go_iiiii_core_ins (
  .clk                  (clk                 ),
  .rst                  (rst                 ),
  .instr                (instr               ),
  .data_from_ram        (data_from_ram       ),
  .alu_result_staged_m  (alu_result_staged_m ),
  .data_to_ram_staged_m (data_to_ram_staged_m),
  .nxt_pc               (nxt_pc              ),
  .mem_op_staged_m      (mem_op_staged_m     ),
  .mem_w_staged_m       (mem_w_staged_m      )
);

data_ram data_ram_ins (
  .clk0                 (clk                 ),
  .wen_n                (~mem_w_staged_m     ), // Need to inverse
  .mem_op               (mem_op_staged_m     ),
  .addr                 (alu_result_staged_m ),
  .din                  (data_to_ram_staged_m),
  .clk1                 (clk                 ),
  .dout                 (data_from_ram       )
);

inst_ram inst_ram_ins (
  .clk1                 (clk                 ),
  .addr1                (nxt_pc              ),
  .instr                (instr               )
);

endmodule