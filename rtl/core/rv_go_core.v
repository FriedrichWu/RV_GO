module rv_go_core (
  input         clk,
  input         rst,
  input  [31:0] instr,
  input  [31:0] data_from_ram,
  output [31:0] alu_result,
  output [31:0] data_to_ram,
  output [31:0] nxt_pc,
  output [ 2:0] mem_op,
  output        mem_w
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
wire [ 1:0] pc_src_b;
wire        alu_src_a;
wire        alu_src_b;
wire [31:0] imm;
wire [31:0] pc;
wire [ 2:0] ext_op;
wire [ 2:0] branch;
wire        mem_to_reg;
//---------------------------------------//
//DATA PATH
//---------------------------------------//
pc pc_ins (
  .clk        (clk   ),
  .rst        (rst   ),
  .nxt_pc     (nxt_pc),
  .pc         (pc    )
);

regfile regfile_ins (
  .clk        (clk         ),
  .raddr1     (instr[19:15]),
  .rdata1     (rs1         ),
  .raddr2     (instr[24:20]),
  .rdata2     (rs2         ),
  .we         (reg_w       ),       // write enable, HIGH valid
  .waddr      (instr[11:7] ),
  .wdata      (data_to_reg )
);

alu alu_ins (
  .alu_ctr    (alu_ctr    ),
  .a          (a          ),
  .b          (b          ),
  .less       (less       ),
  .zero       (zero       ),
  .alu_out    (alu_result )
);

//MUX at b port of alu
always @(*) begin
  b = 32'd4;
  case (alu_src_b)
    2'b00: begin // rs2
      b = rs2;
    end 
    2'b01: begin // imm
      b = imm;
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
assign a = alu_src_a ? pc : rs1;

//Adder and MUX for pc
assign nxt_pc = (pc_src_a ? imm : 32'd4) + (pc_src_b ? rs1 : pc);

//MUX for write back to regfile
assign data_to_reg = mem_to_reg ? data_from_ram : alu_result;

//Connect to datain port of data ram
assign data_to_ram = rs2;

//---------------------------------------//
//CONTROL PATH
//---------------------------------------//
imm_gen imm_gen_ins (
  .instr      (instr      ),
  .ext_op     (ext_op     ),
  .imm        (imm        )
);

contr_gen contr_gen_ins (
  .op         (instr[6:0]  ),
  .func3      (instr[14:12]),
  .func7      (instr[31:25]),
  .ext_op     (ext_op      ),
  .reg_w      (reg_w       ),
  .alu_src_a  (alu_src_a   ),
  .alu_src_b  (alu_src_b   ), 
  .alu_ctr    (alu_ctr     ),
  .branch     (branch      ),
  .mem_to_reg (mem_to_reg  ),
  .mem_w      (mem_w       ),
  .mem_op     (mem_op      )
);

branch_con branch_con_ins (
  .branch     (branch      ),
  .less       (less        ),
  .zero       (zero        ),
  .pc_src_a   (pc_src_a    ),
  .pc_src_b   (pc_src_b    )
);

endmodule