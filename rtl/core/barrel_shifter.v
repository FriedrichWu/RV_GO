module barrel_shifter (
  input      [31:0] din,
  input             l_r, // left or right shift
  input             a_l, // arithmetic or logic shift
  input      [ 4:0] shamt,
  output reg [31:0] dout
);
localparam LEFT_SHIFT  = 1'b1;
localparam RIGHT_SHIFT = 1'b0;
//---------------------------------------------//
//INTERNAL SIGMAL
//---------------------------------------------//
wire       highest_bit;
reg [31:0] stage_0;
reg [31:0] stage_1;
reg [31:0] stage_2;
reg [31:0] stage_3;
reg [31:0] stage_4;
//MUX for highest bit
assign highest_bit = a_l ? din[31] : 1'b0;

//MUX array
always @(*) begin
  case (l_r)
    LEFT_SHIFT: begin
      stage_0 = shamt[0] ? {din[30:0], 1'b0} : din;
      stage_1 = shamt[1] ? {stage_0[29:0], 2'b0} : stage_0;
      stage_2 = shamt[2] ? {stage_1[27:0], 4'b0} : stage_1;
      stage_3 = shamt[3] ? {stage_2[23:0], 8'b0} : stage_2;
      dout    = shamt[4] ? {stage_3[15:0], 16'b0} : stage_3; 
    end
    RIGHT_SHIFT: begin
      stage_0 = shamt[0] ? {highest_bit, din[31:1]} : din;
      stage_1 = shamt[1] ? {{2{highest_bit}}, stage_0[31:2]} : stage_0;
      stage_2 = shamt[2] ? {{4{highest_bit}}, stage_1[31:4]} : stage_1;
      stage_3 = shamt[3] ? {{8{highest_bit}}, stage_2[31:8]} : stage_2;
      dout    = shamt[4] ? {{16{highest_bit}}, stage_3[31:16]} : stage_3; 
    end 
    default: begin//left
      stage_0 = shamt[0] ? {din[30:0], 1'b0} : din;
      stage_1 = shamt[1] ? {stage_0[29:0], 2'b0} : stage_0;
      stage_2 = shamt[2] ? {stage_1[27:0], 4'b0} : stage_1;
      stage_3 = shamt[3] ? {stage_2[23:0], 8'b0} : stage_2;
      dout    = shamt[4] ? {stage_3[15:0], 16'b0} : stage_3; 
    end
  endcase
end

endmodule