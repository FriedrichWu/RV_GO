module alu (
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
wire        l_r;
wire        a_l;
wire        u_s;
wire        s_a;
wire        carry;
wire        overflow;
//------------------------------------------//
//ALU control
//------------------------------------------//
assign l_r = (alu_ctr[2:0] == 3'b001) ? 1'b1 : 1'b0;
assign a_l = alu_ctr[3]; // 1 for arithmetic right shift, 0 for logic right shift
assign u_s = alu_ctr[3]; // 0 for signed, 1 for unsigned compare
assign s_a = alu_ctr[3]; // 1 for sub, 0 for add 
//------------------------------------------//
//Barrel shifter
//------------------------------------------//
barrel_shifter barrel_shifter_ins (
  .din           (a     ),
  .l_r           (l_r   ), // left or right shift
  .a_l           (a_l   ), // arithmetic or logic shift
  .shamt         (b[4:0]),
  .dout          (shift )
);
//-------------------------------------------//
//Adder
//-------------------------------------------//
adder  adder_ins (
  .s_a           (s_a     ), // sub or add control, actually happens to be carry_in, 1 for sub, 0 for add
  .a             (a       ),
  .b             (b       ),
  .carry         (carry   ),
  .zero          (zero    ),
  .overflow      (overflow),
  .result        (adder   )
);
//Generate the compare result
assign less = u_s ? (s_a ^ carry) : (overflow ^ adder[31]); // u_s -> signed for 0, unsigned for 1; less -> a<b: 1, a>b:0
//Extend the compare result to 32bit, which means get 32'b0 if a == b
assign slt = {32{less}};
//-------------------------------------------//
//Logic operation
//-------------------------------------------//
assign xor_out = a ^ b;
assign or_out  = a | b;
assign and_out = a & b;
//-------------------------------------------//
//Output MUX
//-------------------------------------------//
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