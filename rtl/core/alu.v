module alu(
  input      [ 3:0] alu_ctr,
  input      [31:0] a,
  input      [31:0] b,
  output            less,
  output            zero,
  output reg [31:0] alu_out
);
localparam ADDER       = 3'b000;
localparam SHIFT_LEFT  = 3'b001;
localparam SLT         = 3'b010;
localparam B           = 3'b011;
localparam XOR         = 3'b100;
localparam SHIFT_RIGHT = 3'b101;
localparam OR          = 3'b110;
localparam AND         = 3'b111;
//------------------------------------------//
//INTERNAL SIGNAL
//------------------------------------------//
wire [31:0] adder;
wire [31:0] shift;
wire [31:0] slt;
wire [31:0] xor_out;
wire [31:0] or_out;
wire [31:0] and_out;

//Barrel shifter
barrel_shifter barrel_shifter_ins(
  .din(a),
  .l_r(), //left or right shift
  .a_l(), //arithmetic or logic shift
  .shamt(b[4:0]),
  .dout()
);

//Output MUX
always @(*) begin
  case (alu_ctr[2:0])
	ADDER: begin
	  alu_out = adder;
	end
	SHIFT_LEFT: begin
	  alu_out = shift;
	end
	SLT: begin
	  alu_out = slt;
	end
	B: begin
	  alu_out = b;
	end
	XOR: begin
	  alu_out = xor_out;
	end
	SHIFT_RIGHT: begin
	  alu_out = shift;
	end
	OR: begin
	  alu_out = or_out;
	end
	AND: begin
	  alu_out = and_out;
	end
	default: alu_out = b; 
  endcase
end

endmodule