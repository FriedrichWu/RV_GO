module rv_go_iiiii_core (
  input         clk,
  input         rst,
  input  [31:0] instr,
  input  [31:0] data_from_ram,
  output [31:0] alu_result_staged_m,
  output [31:0] data_to_ram_staged_m,
  output [31:0] nxt_pc,
  output [ 2:0] mem_op_staged_m,
  output        mem_w_staged_m
);
//---------------------------------------//
//INTERNAL SIGNAL
//---------------------------------------//
wire [31:0] rs1;
wire [31:0] rs2;
wire        reg_w;
wire [31:0] data_to_reg;
wire [ 3:0] alu_ctr;
wire [31:0] a;
reg  [31:0] b;
wire        less;
wire        zero;
wire        pc_src_a;
wire        pc_src_b;
wire        alu_src_a;
wire [1:0]  alu_src_b;
wire [31:0] imm;
wire [31:0] pc;
wire [ 2:0] ext_op;
wire [ 2:0] branch;
wire        mem_to_reg;
wire [31:0] data_to_ram;
wire        mem_w;
wire [ 2:0] mem_op; 
wire [31:0] alu_result;
//Staged signal
wire [31:0] rs1_staged_e;
wire [31:0] rs2_staged_e;
wire [31:0] pc_staged_e;
wire [31:0] imm_staged_e;
wire        reg_w_staged_e;
wire        reg_w_staged_m;
wire        reg_w_staged_w;
wire        alu_src_a_staged_e;
wire [ 1:0] alu_src_b_staged_e;
wire [ 3:0] alu_ctr_staged_e;
wire [ 2:0] branch_staged_e;
wire        mem_to_reg_staged_e;
wire        mem_to_reg_staged_m;
wire        mem_to_reg_staged_w;
wire        mem_w_staged_e;
wire [ 2:0] mem_op_staged_e;
wire [31:0] alu_result_staged_w;
//---------------------------------------//
//DATA PATH
//---------------------------------------//
pc pc_ins (
  .clk        (clk   ),
  .rst        (rst   ),
  .nxt_pc     (nxt_pc),
  .pc         (pc    )
);
pipeline_reg #(32) pc_staged_e_ins (clk, rst, pc, pc_staged_e); // Since PC self is reg, do not need pc -> d reg

regfile regfile_ins (
  .clk        (clk           ),
  .raddr1     (instr[19:15]  ),
  .rdata1     (rs1           ),
  .raddr2     (instr[24:20]  ),
  .rdata2     (rs2           ),
  .we         (reg_w_staged_w), // write enable, HIGH valid
  .waddr      (instr[11:7]   ),
  .wdata      (data_to_reg   )
);
pipeline_reg #(32) rs1_staged_e_ins (clk, rst, rs1, rs1_staged_e);
pipeline_reg #(32) rs2_staged_e_ins (clk, rst, rs2, rs2_staged_e);

alu alu_ins (
  .alu_ctr    (alu_ctr_staged_e),
  .a          (a               ),
  .b          (b               ),
  .less       (less            ),
  .zero       (zero            ),
  .alu_out    (alu_result      )
);
pipeline_reg #(32) alu_result_staged_m_ins (clk, rst, alu_result, alu_result_staged_m);
pipeline_reg #(32) alu_result_staged_w_ins (clk, rst, alu_result_staged_m, alu_result_staged_w);

imm_gen imm_gen_ins (
  .instr      (instr ),
  .ext_op     (ext_op),
  .imm        (imm   )
);
pipeline_reg #(32) imm_staged_e_ins (clk, rst, imm, imm_staged_e);

//MUX at b port of alu
always @(*) begin
  b = 32'd4;
  case (alu_src_b_staged_e)
    2'b00: begin // rs2
      b = rs2_staged_e;
    end 
    2'b01: begin // imm
      b = imm_staged_e;
    end
    2'b10: begin // 4, for jal and jalr, store the nxt pc address of pc (function reture)
      b = 32'd4;
    end
    default: begin
      b = 32'd4;
    end
  endcase
end

//MUX at a port of alu
assign a = alu_src_a_staged_e ? pc_staged_e : rs1_staged_e;

//Adder and MUX for pc
assign nxt_pc = (pc_src_a ? imm_staged_e : 32'd4) + (pc_src_b ? rs1_staged_e : pc_staged_e);

//MUX for write back to regfile
assign data_to_reg = mem_to_reg_staged_w ? data_from_ram : alu_result_staged_w;

//Connect to datain port of data ram
assign data_to_ram = rs2;
pipeline_reg #(32) data_to_ram_staged_m_ins (clk, rst, data_to_ram, data_to_ram_staged_m);

//---------------------------------------//
//CONTROL PATH
//---------------------------------------//
contr_gen contr_gen_ins (
  .op         (instr[6:0]  ),
  .func3      (instr[14:12]),
  .func7      (instr[31:25]),
  .ext_op     (ext_op      ),
  .reg_w      (reg_w       ), // w
  .alu_src_a  (alu_src_a   ), // e
  .alu_src_b  (alu_src_b   ), // e
  .alu_ctr    (alu_ctr     ), // e
  .branch     (branch      ), // e
  .mem_to_reg (mem_to_reg  ), // w
  .mem_w      (mem_w       ), // m
  .mem_op     (mem_op      ) // m
);
pipeline_reg #(1) reg_w_staged_e_ins (clk, rst, reg_w, reg_w_staged_e);
pipeline_reg #(1) reg_w_staged_m_ins (clk, rst, reg_w_staged_e, reg_w_staged_m);
pipeline_reg #(1) reg_w_staged_w_ins (clk, rst, reg_w_staged_m, reg_w_staged_w);
pipeline_reg #(1) alu_src_a_staged_e_ins (clk, rst, alu_src_a, alu_src_a_staged_e);
pipeline_reg #(2) alu_src_b_staged_e_ins (clk, rst, alu_src_b, alu_src_b_staged_e);
pipeline_reg #(4) alu_ctr_staged_e_ins (clk, rst, alu_ctr, alu_ctr_staged_e);
pipeline_reg #(3) branch_staged_e_ins (clk, rst, branch, branch_staged_e);
pipeline_reg #(1) mem_to_reg_staged_e_ins (clk, rst, mem_to_reg, mem_to_reg_staged_e);
pipeline_reg #(1) mem_to_reg_staged_m_ins (clk, rst, mem_to_reg_staged_e, mem_to_reg_staged_m);
pipeline_reg #(1) mem_to_reg_staged_w_ins (clk, rst, mem_to_reg_staged_m, mem_to_reg_staged_w);
pipeline_reg #(1) mem_w_staged_e_ins (clk, rst, mem_w, mem_w_staged_e);
pipeline_reg #(1) mem_w_staged_m_ins (clk, rst, mem_w_staged_e, mem_w_staged_m);
pipeline_reg #(3) mem_op_staged_e_ins (clk, rst, mem_op, mem_op_staged_e);
pipeline_reg #(3) mem_op_staged_m_ins (clk, rst, mem_op_staged_e, mem_op_staged_m);

branch_con branch_con_ins (
  .branch     (branch_staged_e),
  .less       (less           ),
  .zero       (zero           ),
  .pc_src_a   (pc_src_a       ),
  .pc_src_b   (pc_src_b       )
);

endmodule