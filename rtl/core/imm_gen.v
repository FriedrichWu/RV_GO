module imm_gen (
  input      [24:0] instr,
  input      [ 2:0] ext_op,
  output reg [31:0] imm
);
//------------------------------------------------//
//INTERNAL SIGNAL
//------------------------------------------------//
wire [31:0] immI;
wire [31:0] immU;
wire [31:0] immS;
wire [31:0] immB;
wire [31:0] immJ;
//Sign extension
assign immI = {{20{instr[31]}}, instr[31:20]};
assign immU = {instr[31:12], 12'b0};
assign immS = {{20{instr[31]}}, instr[31:25], instr[11:7]};
assign immB = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
assign immJ = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
//MUX
always @(*) begin
  case (ext_op)
    3'b000: begin
      imm = immI;
    end
    3'b001: begin
      imm = immU;
    end
    3'b010: begin
      imm = immS;
    end
    3'b011: begin
      imm = immB;
    end
    3'b100: begin
      imm = immJ;
    end
    default: begin
      imm = immI;
    end
  endcase
end

endmodule