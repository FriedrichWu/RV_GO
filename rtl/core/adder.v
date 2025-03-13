module adder (
  input         s_a, // sub or add control, actually happens to be carry_in, 1 for sub, 0 for add
  input  [31:0] a,
  input  [31:0] b,
  output        carry,
  output        zero,
  output        overflow,
  output [31:0] result
);
//------------------------------------------//
//INTERNAL SIGNAL
//------------------------------------------//
wire [31:0] t_no_Cin;
//------------------------------------------//
//Adder logic
//------------------------------------------//
assign t_no_Cin        = b ^ {32{s_a}};
assign {carry, result} = a + t_no_Cin + s_a; 
assign overflow        = (a[31] == t_no_Cin[31]) && (result[31] != a[31]);// special handle smallst minus number for sub
assign zero            = ~(|result);


endmodule