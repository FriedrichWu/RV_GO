module branch_con (
  input      [3:0] branch,
  input            less,
  input            zero,
  output reg       pc_src_a,
  output reg       pc_src_b
);
localparam NOT_JUMP        = 3'b000;
localparam NC_JUMP_PC      = 3'b001;
localparam NC_JUMP_REG     = 3'b010;
localparam BRANCH_EQ       = 3'b100;
localparam BRANCH_NOT_EQ   = 3'b101;
localparam BRANCH_LESS     = 3'b110;
localparam BRANCH_NOT_LESS = 3'b111;
//-----------------------------------//
//INTERNAL SIGNAL
//-----------------------------------//
always @(*) begin
  pc_src_a = 1'b0;
  pc_src_b = 1'b0;
  case (branch)
    NOT_JUMP: begin // NextPC = PC + 4
      pc_src_a = 1'b0;
      pc_src_b = 1'b0;
    end
    NC_JUMP_PC: begin // NextPC = PC + imm
      pc_src_a = 1'b1;
      pc_src_b = 1'b0;
    end
    NC_JUMP_REG: begin // NextPC = rs1 + imm
      pc_src_a = 1'b1;
      pc_src_b = 1'b1;
    end
    BRANCH_EQ: begin // NextPC = PC + 4(not jmp) or NextPC = PC + imm(jmp)
      pc_src_a = zero;
      pc_src_b = 1'b0;
    end
    BRANCH_NOT_EQ: begin // NextPC = PC + 4(not jmp) or NextPC = PC + imm(jmp)
      pc_src_a = ~zero;
      pc_src_b = 1'b0;	
    end
    BRANCH_LESS: begin // NextPC = PC + 4(not jmp) or NextPC = PC + imm(jmp)
      pc_src_a = less;
      pc_src_b = 1'b0;
    end
    BRANCH_NOT_LESS: begin // NextPC = PC + 4(not jmp) or NextPC = PC + imm(jmp)
      pc_src_a = ~less;
      pc_src_b = 1'b0;
    end
    default: begin
      pc_src_a = 1'b0;
      pc_src_b = 1'b0;	
    end
  endcase
end
endmodule